class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }

  # enforces validation on password and password_confirmation attributes
  #
  # automatically adds an authenticate method to the corresponding model objects
  has_secure_password

  before_save { self.email = email.downcase }   # self keyword is optional on the right hand side
end
