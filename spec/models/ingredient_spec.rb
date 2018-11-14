require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it 'has a name field' do
    expect(Ingredient.new).to respond_to(:name)
  end
end
