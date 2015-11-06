class StagesController < ApplicationController
  before_action :find_stage, only: [:edit, :update, :destroy]

  def index
    @stages = Stage.all
  end

  def new
    @stage = Stage.new
  end

  def create
    @stage = Stage.new(stage_params)

    if @stage.save
      redirect_to @stage, notice: 'success'
    else
      render :new
    end
  end

  def update
    if @stage.update(stage_params)
      redirect_to @stage, notice: 'success'
    else
      render :edit
    end
  end

  def destroy
    @stage.destroy
    redirect_to stages_url
  end

  private

  def find_stage
    @stage = Stage.find(params[:id])
  end

  def stage_params
    params.require(:stage).permit(:url, :comment, :locked)
  end
end
