class FileInfosController < ApplicationController
  # We do not force authentification when we retrieve a file (use custom token instead)
  skip_before_action :authenticate_user!, only: [:find]
  # We check params for find and regen_token (allow us to render a bad_request in case of missing params)
  before_action :check_params, only: [:find, :regen_token]
  
  # Handle the uploading of a file (POST: "/file_infos")
  def create
    # Create a file using params given
    @file = FileInfo.new params_permit
    # If the file save (and so validation is OK)
    if @file.save
      # We change the name of the blob (to put the same as the tag)
      @file.file.blob.update(filename: "#{@file.tag}.#{@file.file.filename.extension}")
      # And respond to request
      respond_to do |format|
        format.html  { redirect_to(root_url, notice: 'File was successfully created.') }
      end
    # If the file wasn't saved
    else
      # We respond to the request with an alert showing errors
      respond_to do |format|
        format.html  { redirect_to(root_url, alert: "Error when creatings file: #{@file.errors.full_messages.join(' and ')}") }
      end
    end
  end

  # Handle the research of a file (GET: "/file?[tag|name|path|title]=<...>[&token=<...>]")
  def find
    # Try to find the file wanted
    @file = find_file

    # If we found a file
    if @file
      # If the file is secure with a token
      if @file.should_be_secure
        # We check if the token and the file are the same
        if find_params_permit[:token] != @file.token
          # If not, we respond with a not_found (to not give info that the file exists as does GitHub / GitLab)
          return respond_to do |format|
            format.html { head :not_found }
          end
        end
      end
      # If the file is not secure OR the token is correct, we redirect user to the file url
      redirect_to(@file.file_url, allow_other_host: true)
    else
      # If we don't find a matching file we respond with not found
      respond_to do |format|
        format.html { head :not_found }
      end
    end
  end

  # Handle the regeneration of a token for a file (POST: "/file/regen_token?[tag|name|path|title]=<...>")
  def regen_token
    # Try to find the file wanted
    @file = find_file

    # If we found a file
    if @file
      # We update the file token with a new one
      if @file.update(token: @file.generate_token)
        # And respond with a success notice
        respond_to do |format|
          format.html { redirect_to(root_url, notice: "File Token was successfully regenerate.") }
        end
      # If an error happend
      else
        # We tell it to the user with an alert
        respond_to do |format|
          format.html { redirect_to(root_url, alert: "File Token wasn't successfully regenerate: #{@file.errors.full_messages.join(' and ')}") }
        end
      end
    else
      # 404 if the file doesn't exist
      respond_to do |format|
        format.html { head :not_found }
      end
    end
  end

  # Handle deletion of a file (DELETE: "/file?[tag|name|path|title]=<...>")
  def delete
    # Try to find the file wanted
    @file = find_file

    # If we found a file
    if @file
      # We destroy the file
      if @file.destroy
        # And inform user of the success
        respond_to do |format|
          format.html { redirect_to(root_url, notice: "File was delete.") }
        end
      # If the destroy had an error
      else
        # We also inform user
        respond_to do |format|
          format.html { redirect_to(root_url, alert: "File wasn't delete: #{@file.errors.full_messages.join(' and ')}") }
        end
      end
    else
      # 404 if the file doesn't exist
      respond_to do |format|
        format.html { head :not_found }
      end
    end
  end

  private

  # Params permit to upload a file
  def params_permit
    params.require(:file_info).permit(:tag, :file, :should_be_secure)
  end

  # Searching params names allow in the URL
  def searching_attributes
    [:tag, :name, :path, :title]
  end
  
  # Params permit when searching a file or performing action on a specific file
  def find_params_permit
    params.permit([searching_attributes] + [:token])
  end

  # Helpers method who research file
  def find_file
    # Try to find the params use in URL
    use_attributes = searching_attributes.find { |sa| find_params_permit.has_key? sa  }
    # Try to find file using attribute provide
    FileInfo.find_by(tag: find_params_permit[use_attributes])
  end

  # Check if minimum params are provides
  def check_params
    if find_params_permit.empty?
      respond_to do |format|
        format.html { head :bad_request }
      end
      return
    end
  end
end
