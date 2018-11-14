require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  it 'has a quantity field' do
    expect(RecipeIngredient.new).to respond_to(:quantity)
  end
end
