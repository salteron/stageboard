require 'rails_helper'

RSpec.describe StagesController, type: :controller do
  describe 'GET index' do
    let!(:stage) { Stage.create(name: 'name', url: 'url') }
    before { get :index }
    it { expect(assigns(:stages)).to eq Array.wrap(stage) }
  end

  describe 'GET new' do
    before { get :new }
    it { expect(assigns(:stage)).to be_a_new(Stage) }
  end

  describe 'POST create' do
    context 'when valid args' do
      before do
        post :create, stage: {name: 'name', url: 'url', comment: 'comment', locked: true, uuid: 'foo'}
      end

      it do
        stage = assigns(:stage)
        expect(stage).to_not be_new_record
        expect(flash[:notice]).to eq 'success'
        expect(stage.name).to eq 'name'
        expect(stage.url).to eq 'url'
        expect(stage.comment).to eq 'comment'
        expect(stage.locked).to be_truthy
        expect(stage.uuid).to_not eq 'foo'
        expect(response).to redirect_to(stage_url(stage))
      end
    end

    context 'when invalid args' do
      before { post :create, stage: {name: 'name'} }

      it do
        stage = assigns(:stage)
        expect(stage).to be_new_record
        expect(flash[:notice]).to be_nil
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET edit' do
    let!(:stage) { Stage.create(name: 'name', url: 'url') }

    context 'when existing stage' do
      before { get :edit, id: stage.id }
      it { expect(assigns(:stage)).to eq stage }
    end

    context 'when not existing stage' do
      before { get :edit, id: 0 }
      it { expect(response).to render_template('shared/errors/404') }
    end
  end

  describe 'PUT update' do
    let!(:stage) { Stage.create(name: 'name', url: 'url') }

    context 'when valid args' do
      before do
        put :update, id: stage.id, stage: {locked: true, comment: %q(can't touch this), uuid: 'foo'}
      end

      it do
        stage = assigns(:stage)
        expect(stage).to eq stage
        expect(flash[:notice]).to eq 'success'
        expect(stage.locked).to be_truthy
        expect(stage.comment).to eq %q(can't touch this)
        expect(stage.uuid).to_not eq 'foo'
        expect(response).to redirect_to(stage_url(stage))
      end
    end

    context 'when invalid args' do
      before { put :update, id: stage.id, stage: {name: ''} }

      it do
        stage = assigns(:stage)
        expect(stage).to eq stage
        expect(flash[:notice]).to be_nil
        expect(response).to render_template(:edit)
      end
    end

    context 'when stage not found' do
      before { put :update, id: 0 }
      it { expect(response).to render_template('shared/errors/404') }
    end
  end

  describe 'GET show' do
    let!(:stage) { Stage.create(name: 'name', url: 'url') }
    before { get :show, id: stage.id }
    it { expect(assigns(:stage)).to eq stage }
  end

  describe 'DELETE destroy' do
    let!(:stage) { Stage.create(name: 'name', url: 'url') }

    context 'when existing stage' do
      before { delete :destroy, id: stage.id }
      it { expect(Stage.count).to be 0 }
    end

    context 'when existing stage' do
      before { delete :destroy, id: 0 }
      it { expect(Stage.count).to be 1 }
    end
  end
end
