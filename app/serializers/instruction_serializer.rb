class InstructionSerializer < ActiveModel::Serializer
  attributes :id, :description, :recipe_id

  belongs_to :recipe
end
