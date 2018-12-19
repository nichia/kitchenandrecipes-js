class Instruction < ApplicationRecord
  belongs_to :recipe

  scope :ordered_instructions, -> { order("id ASC") }

end
