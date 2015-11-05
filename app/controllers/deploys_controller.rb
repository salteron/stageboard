class DeploysController < ApplicationController
  before_filter :find_stage, only: [:recent, :upcoming]

  def recent
    return head :not_found unless @stage

    @stage.upcoming_deploy.try(:destroy)

    deploy = @stage.recent_deploy || @stage.build_recent_deploy
    deploy.assign_attributes(deploy_params.merge!(finished_at: Time.now.utc))

    head deploy.save ? :no_content : :unprocessable_entity
  end

  def upcoming
    return head :not_found unless @stage

    deploy = @stage.upcoming_deploy || @stage.build_upcoming_deploy
    deploy.assign_attributes(deploy_params)

    head deploy.save ? :no_content : :unprocessable_entity
  end

  private

  def deploy_params
    params.require(:deploy).permit(:branch, :initiated_by)
  end

  def find_stage
    @stage = Stage.find_by_uuid(params[:stage_uuid])
  end
end
