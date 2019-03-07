class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :email, :provider, :name, :first_name, :last_name, :avatar

  has_many :recipes
  has_many :reviews

  def avatar
    rails_blob_path(object.avatar, only_path: true) if object.avatar.attached?
  end
end
