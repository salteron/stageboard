class DeploysController < ApplicationController
  before_filter :find_stage, only: [:recent, :upcoming]

  rescue_from ActionController::ParameterMissing, with: :unprocessable_entity

  def recent
    return head :not_found unless @stage

    @stage.upcoming_deploy.try(:destroy)

    return head :unprocessable_entity unless complete_params?

    deploy = @stage.recent_deploy || @stage.build_recent_deploy
    deploy.assign_attributes(deploy_params.merge!(finished_at: Time.now.utc))

    head deploy.save ? :no_content : :unprocessable_entity
  end

  def upcoming
    return head :not_found unless @stage
    return head :unprocessable_entity unless complete_params?
    return head :locked if @stage.locked?(deploy_params[:branch]) # 423 = :locked

    deploy = @stage.upcoming_deploy || @stage.build_upcoming_deploy
    deploy.assign_attributes(deploy_params)

    head deploy.save ? :no_content : :unprocessable_entity
  end

  private

  def deploy_params
    params.require(:deploy).permit(:branch, :initiated_by)
  end

  def complete_params?
    deploy_params[:branch].present?
  end

  def find_stage
    @stage = Stage.find_by_uuid(params[:stage_uuid])
  end

  def unprocessable_entity
    head :unprocessable_entity
  end
end
