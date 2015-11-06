require 'rails_helper'

RSpec.describe LocksController, type: :controller do
  let(:stage) { create(:stage) }
  let(:lock) { create(:lock, stage_id: stage.id) }

  describe 'GET new' do
    context 'when existing stage specified' do
      before { get :new, stage_id: stage.id }

      it { expect(assigns(:lock)).to be_a_new(Lock) }
      it { expect(response).to render_template(:new) }
    end

    context 'when absent stage specified' do
      before { get :new, stage_id: 0 }
      it { expect(response).to render_template('shared/errors/404') }
    end
  end

  describe 'GET edit' do
    context 'when existing stage and lock exists' do
      before do
        lock
        get :edit, stage_id: stage.id
      end

      it { expect(assigns(:stage)).to eq stage }
      it { expect(assigns(:lock)).to eq lock }
      it { expect(response).to render_template(:edit) }
    end

    context 'when existing stage and lock does not exist' do
      before do
        stage
        get :edit, stage_id: stage.id
      end

      it { expect(assigns(:stage)).to eq stage }
      it { expect(response).to redirect_to(new_stage_lock_url(stage)) }
    end

    context 'when stage not exists' do
      before { get :edit, stage_id: 0 }
      it { expect(response).to render_template('shared/errors/404') }
    end
  end

  describe 'POST create' do
    context 'when stage not exists' do
      before { post :create, stage_id: 0 }
      it { expect(response).to render_template('shared/errors/404') }
    end

    context 'when lock already exists' do
      before do
        post :create, stage_id: lock.stage_id, lock: { foo: :bar }
      end

      it { expect(response).to redirect_to(stages_url) }
    end

    context 'when valid params' do
      before do
        post :create, stage_id: stage.id, lock: attributes_for(:lock)
      end

      it do
        expect(flash[:notice]).to eq 'success'
        expect(stage.lock).to be_present
        expect(response).to redirect_to(stages_url)
      end
    end

    context 'when invalid params' do
      before do
        post :create, stage_id: stage.id, lock: attributes_for(:lock).except!(:expired_at)
      end

      it do
        lock = assigns(:lock)
        expect(lock).to be_new_record
        expect(flash[:notice]).to be_nil
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT update' do
    context 'when stage not exists' do
      before { put :update, stage_id: 0 }
      it { expect(response).to render_template('shared/errors/404') }
    end

    context 'when lock not exists' do
      before { put :update, stage_id: stage.id, lock: attributes_for(:lock) }
      it { expect(response).to render_template('shared/errors/404') }
    end

    context 'when valid params' do
      before { put :update, stage_id: lock.stage_id, lock: attributes_for(:lock, initiated_by: 'test') }

      it do
        expect(flash[:notice]).to eq 'success'
        expect(stage.lock).to be_present
        expect(stage.lock.initiated_by).to eq 'test'
        expect(response).to redirect_to(stages_url)
      end
    end

    context 'when invalid params' do
      before do
        put :update, stage_id: lock.stage_id, lock: attributes_for(:lock, initiated_by: '')
      end

      it do
        lock = assigns(:lock)
        expect(lock).to eq lock
        expect(flash[:notice]).to be_nil
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when lock exists' do
      before { delete :destroy, stage_id: lock.stage_id }
      it { expect(Lock.count).to be 0 }
    end

    context 'when lock does not exist' do
      before { delete :destroy, stage_id: stage.id }
      it { expect(Lock.count).to be 0 }
    end
  end
end
