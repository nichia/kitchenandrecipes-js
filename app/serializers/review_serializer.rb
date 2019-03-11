class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :recipe_id, :rating, :comment

  belongs_to :reviewer
  belongs_to :recipe
end
