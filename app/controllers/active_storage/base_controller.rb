# frozen_string_literal: true

# The base class for all Active Storage controllers.
class ActiveStorage::BaseController < ActionController::Base
  before_action :check_token_tag
  include ActiveStorage::SetCurrent

  protect_from_forgery with: :exception

  self.etag_with_template_digest = false

  def check_token_tag
    return if params[:controller] == "active_storage/disk"
    if params[:tag].nil?
      head :bad_request
    else
      file = FileInfo.find_by(tag: params[:tag])
      if file.should_be_secure
        if params[:token].nil?
          head :bad_request
        elsif params[:token] != file.token
          head :not_found
        end
      end
    end
  end
end
