class FileInfosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:find]
  before_action :check_params, only: [:find, :regen_token]
  
  def create
    @file = FileInfo.new params_permit
    if @file.save
      @file.file.blob.update(filename: "#{@file.tag}.#{@file.file.filename.extension}")
      respond_to do |format|
        format.html  { redirect_to(root_url, notice: 'File was successfully created.') }
      end
    else
      respond_to do |format|
        format.html  { redirect_to(root_url, alert: "Error when creatings file: #{@file.errors.full_messages.join(' and ')}") }
      end
    end
  end

  def find
    @file = find_file

    if @file
      if @file.should_be_secure
        if find_params_permit[:token] != @file.token
          return respond_to do |format|
            format.html { head :not_found }
          end
        end
      end        
      redirect_to(url_for(@file.file))
    else
      respond_to do |format|
        format.html { head :not_found }
      end
    end
  end

  def regen_token
    @file = find_file
    if @file
      if @file.update(token: @file.generate_token)
        respond_to do |format|
          format.html { redirect_to(root_url, notice: "File Token was successfully regenerate.") }
        end
      else 
        respond_to do |format|
          format.html { redirect_to(root_url, alert: "File Token wasn't successfully regenerate: #{@file.errors.full_messages.join(' and ')}") }
        end
      end
    else
      respond_to do |format|
        format.html { head :not_found }
      end
    end
  end

  private

  def params_permit
    params.require(:file_info).permit(:tag, :file, :should_be_secure)
  end

  def searching_attributes
    [:tag, :name, :path, :title]
  end
  
  def find_params_permit
    params.permit([searching_attributes] + [:token])
  end

  def find_file
    use_attributes = searching_attributes.find { |sa| find_params_permit.has_key? sa  }
    FileInfo.find_by(tag: find_params_permit[use_attributes])
  end

  def check_params
    if find_params_permit.empty?
      respond_to do |format|
        format.html { head :bad_request }
      end
      return
    end
  end
end
