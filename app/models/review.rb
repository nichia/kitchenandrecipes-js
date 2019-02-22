class Review < ApplicationRecord
  paginates_per 15

  belongs_to :reviewer, class_name: :User, foreign_key: :user_id, optional: :true
  belongs_to :recipe, optional: :true

  validates :rating, presence: true
  validates :comment, presence: true
end
