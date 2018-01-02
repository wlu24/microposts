class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  # in the case of a :followers attribute, Rails will singularize “followers”
  # and automatically look for the foreign key follower_id in this case
  #
  # keep the :source key to emphasize the parallel structure with the
  # has_many :following association.
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest


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

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")  # self is omitted on send()
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    # self is an instance of User, aka a row/entry in the User table
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    # self is an instance of User, aka a row/entry in the User table
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago # password reset sent earlier than two hours ago.
  end


  def feed
    # self.following_ids    self omitted
    #
    # the following_ids method is synthesized by Active Record based on the
    # has_many :following association; the result is that we need
    # only append _ids to the association name to get the ids corresponding to
    # the user.following collection
    #
    # amounts to calling self.following.map(&:id), which returns an array of
    # strings, each is the id of a 'followed' user
    #
    # this implementation is inefficient because pulls all the followed users’
    # ids into memory, and creates an array the full length of the followed
    # users array
    #
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)



    # A more efficient implementation using a subquery.
    # This arranges for all the set logic to be pushed into the database.
    #
    # For yet more efficient implementation, look into how to generate the feed
    # asynchronously using a background job
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)


  end




  # Follows a user.
  def follow(other_user)
    # from Ruby on Rails 5.1.4 documentation:
    # Module
    # ActiveRecord::Associations::ClassMethods
    # activerecord/lib/active_record/associations.rb
    #
    # method collection<<(object, …):
    #
    # Adds one or more objects to the collection by
    # creating associations in the join table (collection.push and
    # collection.concat are aliases to this method). Note that this operation
    # instantly fires update SQL without waiting for the save or update call
    # on the parent object, unless the parent object is a new record.
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end




  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase # self keyword is optional on the right hand side
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
