class User < ApplicationRecord
  has_many :role_users, dependent: :destroy
  has_many :roles, through: :role_users
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :reports, dependent: :destroy

  attr_accessor :remember_token

  VALID_EMAIL_REGEX = Settings.email.regex

  validates :email, presence: true,
            length: {maximum: Settings.digits.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.digits.length_6},
            allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
    remember_digest
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = begin
      send "#{attribute}_digest"
    rescue NoMethodError
      nil
    end
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  # Returns a session token to prevent session hijacking.
  # We reuse the remember digest for convenience.
  def session_token
    remember_digest || remember
  end
end
