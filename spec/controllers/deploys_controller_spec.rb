require 'rails_helper'

RSpec.describe DeploysController, type: :controller do
  describe 'POST recent' do
    describe 'when stage does not exist' do
      before { post :recent, stage_uuid: 0, deploy: { branch: :develop } }
      it { expect(response).to have_http_status(:not_found) }
    end

    describe 'when stage exists' do
      let(:stage) { Stage.create(url: 'url') }

      context 'when correct deploy params' do
        before { post :recent, stage_uuid: stage.uuid, deploy: { branch: :develop } }

        it do
          expect(stage.recent_deploy).to be_present
          expect(stage.upcoming_deploy).to_not be_present
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when incorrect deploy params' do
        before { post :recent, stage_uuid: stage.uuid, deploy: {foo: :bar} }

        it do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(stage.upcoming_deploy).to_not be_present
          expect(stage.recent_deploy).to_not be_present
        end
      end

      context 'when deploy already exists' do
        let!(:deploy) { stage.create_recent_deploy(branch: :develop, finished_at: Time.now) }

        before { post :recent, stage_uuid: stage.uuid, deploy: {branch: :master} }

        it do
          expect(response).to have_http_status(:no_content)
          expect(Deploy.where(:stage_id => stage.id).count).to eq 1
        end
      end

      context 'when upcoming deploy exists' do
        before do
          stage.create_upcoming_deploy(branch: :develop)
          post :recent, stage_uuid: stage.uuid, deploy: {branch: :master}
          stage.reload
        end

        it { expect(stage.recent_deploy).to be_present }
        it { expect(stage.upcoming_deploy).to_not be_present }
      end
    end
  end

  describe 'POST upcoming' do
    describe 'when stage does not exist' do
      before { post :upcoming, stage_uuid: 0, deploy: { branch: :develop } }
      it { expect(response).to have_http_status(:not_found) }
    end

    describe 'when stage exists' do
      let(:stage) { Stage.create(url: 'url') }

      context 'when correct deploy params' do
        before { post :upcoming, stage_uuid: stage.uuid, deploy: { branch: :develop } }

        it do
          expect(stage.upcoming_deploy).to be_present
          expect(stage.recent_deploy).to_not be_present
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when incorrect deploy params' do
        before { post :upcoming, stage_uuid: stage.uuid, deploy: {foo: :bar} }

        it do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(stage.upcoming_deploy).to_not be_present
          expect(stage.recent_deploy).to_not be_present
        end
      end

      context 'when deploy already exists' do
        let!(:deploy) { stage.create_upcoming_deploy(branch: :develop) }

        before { post :upcoming, stage_uuid: stage.uuid, deploy: {branch: :master} }

        it do
          expect(response).to have_http_status(:no_content)
          expect(Deploy.where(:stage_id => stage.id).count).to eq 1
        end
      end
    end
  end
end
