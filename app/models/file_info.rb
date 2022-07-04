class FileInfo < ApplicationRecord
  has_one_attached :file
  validates :file, :tag, presence: true
  validates :token, exclusion: { in: [nil] }
  validates :should_be_secure, inclusion: [true, false]
  validates :tag, :token, uniqueness: { case_sensitive: false, allow_blank: true }
  
  before_validation :check_should_be_secure_not_nil
  before_validation :genenerate_assigne_token


  def generate_token
    random_token = nil
    loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break if FileInfo.find_by(token: random_token).nil?
    end
    random_token
  end

  def file_url
    params = ["tag=#{self.tag}"]
    params.append("token=#{self.token}") if self.should_be_secure
    "#{Rails.application.routes.url_helpers.rails_blob_url(self.file)}?#{params.join("&")}"
  end

  def file_representation_url(resize = [300, 300])
    params = ["tag=#{self.tag}"]
    params.append("token=#{self.token}") if self.should_be_secure
    "#{Rails.application.routes.url_helpers.rails_blob_url(self.file.representation(resize_to_limit: resize))}?#{params.join("&")}"
  end

  private

  def genenerate_assigne_token
    self.token = if self.should_be_secure
      generate_token
    else
      ""
    end
  end

  def check_should_be_secure_not_nil
    if self.should_be_secure.nil?
      # By default we secure it
      self.should_be_secure = true
    end
  end
end
