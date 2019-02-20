class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :user_id, :recipe_id, :rating, :comment
end
