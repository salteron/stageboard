# coding: utf-8
class Client
  def upcoming(url, stage_uuid, branch)
    RestClient.post("#{url}/stages/#{stage_uuid}/deploys/upcoming", {deploy: {branch: branch}})
  rescue RestClient::ExceptionWithResponse => e
    raise ArgumentError, 'stage is locked' if e.response.code == 423
  rescue => _
    nil
  end

  def recent(url, stage_uuid, branch)
    RestClient.post("#{url}/stages/#{stage_uuid}/deploys/recent", {deploy: {branch: branch}})
  rescue => _
    nil
  end
end
