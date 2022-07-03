# frozen_string_literal: true

# The base class for all Active Storage controllers.
class ActiveStorage::BaseController < ActionController::Base
  # Before all action of active storage, we check that token and tag are provides and matching
  before_action :check_token_tag
  include ActiveStorage::SetCurrent

  protect_from_forgery with: :exception

  self.etag_with_template_digest = false

  # Check if tag and token are provides and if they are matching
  def check_token_tag
    # If we are in a local developpement, we allow active_storage/disk
    return if params[:controller] == "active_storage/disk"

    # If the tag is not provide
    if params[:tag].nil?
      # Then bad_request
      head :bad_request
    # If the tag is provide
    else
      # We try to found a file using the tag
      file = FileInfo.find_by(tag: params[:tag])

      # If we don't find any file matching the tag provide
      if !file
        # We return a 404
        return head :not_found
      end

      # If the file found is secure
      if file.should_be_secure
        # If the token is not provide
        if params[:token].nil?
          # Then is a 404 to not expose the file existence
          head :not_found
        # If the token is provide but not the correct one
        elsif params[:token] != file.token
          # Then is a 404 to not expose the file existence
          head :not_found
        end
      end
    end
  end
end
