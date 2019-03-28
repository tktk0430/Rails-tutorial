class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 200},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password,length:{minimum: 6}, allow_nil: true
  attr_accessor :remember_token, :activation_token, :reset_token
  
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

  # def authenticated?(remember_token)
  #   return false if self.remember_digest.nil?
  #   BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  # end
  # 下のように書き換え

  def authenticated?(attribute,token)
    digest= self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now #selfはレシーバ
  end

  def create_reset_digest
    self.reset_token=User.new_token
    update_columns(reset_digest:User.digest(reset_token),reset_sent_at:Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now #selfはレシーバ
  end

  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("user_id = ?",self.id)
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
