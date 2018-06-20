class User < ApplicationRecord
  has_secure_password
  has_many :items, dependent: :destroy
  
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence:true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, 
          format: { with: VALID_EMAIL_REGEX },
          uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  validates :address,:phone, presence: true

end