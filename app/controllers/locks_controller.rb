class LocksController < ApplicationController
  before_action :find_stage, only: [:new, :edit, :create, :update, :destroy]

  def new
    @lock = @stage.build_lock
  end

  def edit
    redirect_to(new_stage_lock_url(@stage)) unless (@lock = @stage.lock).present?
  end

  def create
    return redirect_to(stages_url, notice: 'lock already exists') if @stage.lock.present?

    @lock = @stage.build_lock(lock_params)

    if @lock.save
      redirect_to stages_url, notice: 'success'
    else
      render :new
    end
  end

  def update
    return not_found unless (@lock = @stage.lock).present?

    if @lock.update(lock_params)
      redirect_to stages_url, notice: 'success'
    else
      render :edit
    end
  end

  def destroy
    @stage.lock.try(:destroy)
    redirect_to stages_url
  end

  private

  def find_stage
    @stage = Stage.find(params[:stage_id])
  end

  def lock_params
    params.require(:lock).permit(:initiated_by, :expired_at, :branch_whitelist)
  end
end
