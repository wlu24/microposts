class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # 'has_secure_password' includes a separate presence validation that
  # specifically catches nil passwords, so setting allow_nil to true does not
  # allow empty passwords on its own
  # this configuration was needed for the "sucessful edit" test in user_edit test
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  # enforces validation on password and password_confirmation attributes
  #
  # automatically adds an authenticate method to the corresponding model objects
  has_secure_password # method provided by the 'bcrypt' gem

  before_save { self.email = email.downcase }   # self keyword is optional on the right hand side


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  attr_accessor :remember_token
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
