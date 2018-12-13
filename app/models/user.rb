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

  has_many :recipes
  has_many :reviews
  validates_presence_of :email, :name
  validates_uniqueness_of :email

  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

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
    user.update_attributes(provider: auth['provider'], uid: auth['uid'], avatar: URI.parse(auth['info']['image']))
    user
  end

  def self.signup_user_with_provider(auth)
    self.where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
      user.name = auth['info']['name']
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
      if URI.parse(auth['info']['image'])
        # open the link
        # avatar_file = download_remote_file(URI.parse(auth['info']['image']))
        avatar_file = open(auth.info.image)

        # upload via ActiveStorage
        user.avatar.attach(io: avatar_file, filename: "user_avatar_#{user.id}.jpg", content_type: avatar_file.content_type)
      end
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def download_remote_file(url)
     #open(auth.info.image)
     response = Net::HTTP.get_response(URI.parse(url))
     StringIO.new(response.body)
  end

end
