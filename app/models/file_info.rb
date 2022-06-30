class FileInfo < ApplicationRecord
  has_one_attached :file
  validates :file, :tag, presence: true
  validates :tag, uniqueness: { case_sensitive: false }
end
