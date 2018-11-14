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

  has_many :recipes
  has_many :reviews
  validates_presence_of :email, :username
  validates_uniqueness_of :email

  # generate user based on omniauth data received from 3rd party providers
  def self.from_omniauth(auth)
    user = User.find_by_email(auth['info']['email'].downcase)
    if user
      self.update_user_with_provider(user, auth)
    else
      self.signup_user_with_provider(auth)
    end
  end

  def provider_name
    self.provider.titleize
  end

  private

  def self.update_user_with_provider(user, auth)
    user.update_attributes(provider: auth['provider'], uid: auth['uid'], image: URI.parse(auth['info']['image']))
    user
  end

  def self.signup_user_with_provider(auth)
    self.where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
      user.username = auth['info']['name']
      if auth['info']['first_name']
        user.first_name = auth['info']['first_name']
      else
        user.first_name = auth['info']['name'].split(" ", 2)[0]
      end
      if auth.info.last_name
        user.last_name = auth['info']['last_name']
      else
        user.last_name = auth['info']['name'].split(" ", 2)[1]
      end
      user.email = auth['info']['email']
      user.image = URI.parse(auth['info']['image'])
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
