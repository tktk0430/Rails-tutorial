class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 200},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password,length:{minimum: 6}, allow_nil: true
  attr_accessor :remember_token, :activation_token
  #remember(=)メソッドをセッターとゲッターにする
  before_save :downcase_email
  before_create :create_activation_digest

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest,
      User.digest(self.remember_token))
  end

  def forget
    self.update_attribute(:remember_digest,nil)
  end

  def authenticated?(remember_token)
    return false if self.remember_digest.nil?
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  private
    def downcase_email
      self.email=self.email.downcase
    end

    def create_activation_digest
      self.activation_token=User.new_token
      self.activation_digest=User.digest(self.activation_token)
    end
end
