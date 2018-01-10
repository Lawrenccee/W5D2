class User < ApplicationRecord
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :username, :password_digest, presence: true

  has_many :subs,
  foreign_key: :mod_id,
  class_name: :Sub

  has_many :comments,
    foreign_key: :author_id,
    class_name: :Comment,
    inverse_of: :author

  has_many :posts

  before_validation :ensure_session_token

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
end
