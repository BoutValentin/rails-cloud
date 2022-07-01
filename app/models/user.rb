class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable

  validates :email, :password, :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :email, uniqueness: { case_sensitive: false }
end
