require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) {
    Category.create(
      :category_type => "Meal",
      :name => "Appetizers"
    )
  }

  it 'has a category_type field' do
    expect(Category.new).to respond_to(:category_type)
  end

  it 'has a name field' do
    expect(Category.new).to respond_to(:name)
  end

  it "is valid with a category_type and name" do
    expect(category).to be_valid
  end

  it "is not valid without a category_type" do
    expect(Category.new(name: "Breakfast")).not_to be_valid
  end

  it "is not valid without a name" do
    expect(Category.new(category_type: "Origin")).not_to be_valid
  end
end
