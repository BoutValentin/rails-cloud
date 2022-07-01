class FileInfo < ApplicationRecord
  has_one_attached :file
  validates :file, :tag, :token, presence: true
  validates :tag, :token, uniqueness: { case_sensitive: false }

  before_validation :genenerate_assigne_token


  def generate_token
    random_token = nil
    loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break if FileInfo.find_by(token: random_token).nil?
    end
    random_token
  end

  private

  def genenerate_assigne_token
    self.token = generate_token
  end
end
