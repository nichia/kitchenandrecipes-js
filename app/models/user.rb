require 'open-uri'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :recoverable, and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :rememberable,
          :validatable,
          :trackable,
          :omniauthable,
          :omniauth_providers => [:facebook, :github, :google_oauth2]

  has_one_attached :avatar
  has_many :recipes, dependent: :destroy
  has_many :reviews, dependent: :destroy

  EMAIL_REGEX = /\A
    [.A-Za-z0-9_-]      # Must contain alphanumeric, underscore, dashes and '.' characters
    +@[A-Za-z0-9_-]     # Must follow by '@' and alphanumeric, underscore and dashes characters
    +.[A-Za-z]{2,4}\z   # Must follow by '.' and 2 to 4 alphanumeric characters
  /x
  USERNAME_REGEX = /\A
   (?=.{2,})           # Must contain 3 or more characters
   [.A-Za-z0-9_-]+\z    # Must contain alphanumberic, underscore, dashes and '.' characters
  /x
  PASSWORD_FORMAT = /\A
    (?=.{6,})          # Must contain 6 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    # (?=.*[[:^alnum:]]) # Must contain a symbol [POSIX bracket expressions]
  /x

  validates :name,
    presence: { message: "Username must be provided" },
    format: { with: USERNAME_REGEX, message: "Username must include alphanumeric, underscores, dashes and . character" }
  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: EMAIL_REGEX, message: "format must be jsmith@example.com" }
  validates :password,
    presence: true,
    length: { in: 6..64 },
    format: { with: PASSWORD_FORMAT, message: "format must include a digit, symbol, upper and lower cases, and have 6 or more characters" },
    on: :create
    validates :password,
     allow_nil: true,
     length: { in: 6..64 },
     format: { with: PASSWORD_FORMAT, message: "format must include a digit, symbol, upper and lower cases, and have 6 or more characters" },
     on: :update
  validate :avatar_validation  # facebook image is not in png, jpg, jpeg format

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  # generate user based on omniauth data received from 3rd party providers
  def self.from_omniauth(auth)
    @auth = auth
    user = User.find_by_email(@auth['info']['email'].downcase)
    #binding.pry
    if user
      self.update_user_with_provider(user)
    else
      self.signup_user_with_provider
    end
  end

  def provider_name
    self.provider.titleize
  end

  private

  def avatar_validation
    if avatar.attached?
      if !avatar.content_type.in?(['image/gif', 'image/png', 'image/jpg', 'image/jpeg'])
        errors.add(:avatar, 'must be an image file with gif, jpeg, jpg or png format')
      end
    else
      errors.add(:avatar, 'must be added')
    end
  end

  def self.update_user_with_provider(user)
    if user.avatar.attached?
      user.avatar.purge
    end
    user.update_attributes(provider: @auth['provider'], uid: @auth['uid'])
    attach_user_avatar(user)
    user
  end

  def self.signup_user_with_provider
    self.where(provider: @auth['provider'], uid: @auth['uid']).first_or_create do |user|
      user.name = @auth['info']['name'].gsub(/\s+/, "")
      if @auth['info']['first_name']
        user.first_name = @auth['info']['first_name']
      else
        user.first_name = @auth['info']['name'].split(" ", 2)[0]
      end
      if @auth.info.last_name
        user.last_name = @auth['info']['last_name']
      else
        user.last_name = @auth['info']['name'].split(" ", 2)[1]
      end
      user.email = @auth['info']['email']
      user.password = Devise.friendly_token[0, 20]
      attach_user_avatar(user)
    end
  end

  def self.attach_user_avatar(user)
     if URI.parse(@auth['info']['image'])
       avatar_url = open(@auth.info.image)
       # attach image file via ActiveStorage
       user.avatar.attach(io: avatar_url, filename: "user_avatar_#{user.email}.#{avatar_url.content_type.split(/\//).last}", content_type: avatar_url.content_type)
     end
  end
end
