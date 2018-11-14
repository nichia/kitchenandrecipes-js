require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) {
    User.create(
      :username => "Mindy",
      :email => "mindy@email.com",
      :first_name => "Mindy",
      :last_name => "Jones",
      :password => "Password1!",
      :password_confirmation => "Password1!"
    )
  }
  let(:recipe) {
    Recipe.create(
      :title => "Roasted Cauliflower with Turmeric and Cumin",
      :description => "Cauliflower, vibrant yellow from turmeric and fragrant with cumin, cilantro and mint",
      :prep_time => "20 mins",
      :cook_time => "1 hour",
      :yield => "Serve: 8",
      :private => false,
      :source => "uid",
      :url_image => "image",
      :user => user
    )
  }

  it "is valid with a title, description, prep_time, cook_time, yield" do
    expect(recipe).to be_valid
  end

  it 'has a title field' do
    expect(Recipe.new).to respond_to(:title)
  end

  it 'has a description field' do
    expect(Recipe.new).to respond_to(:description)
  end

  it 'has a prep_time field' do
    expect(Recipe.new).to respond_to(:prep_time)
  end

  it 'has a cook_time field' do
    expect(Recipe.new).to respond_to(:cook_time)
  end

  it 'has a yield field' do
    expect(Recipe.new).to respond_to(:yield)
  end

  it 'has a private field' do
    expect(Recipe.new).to respond_to(:private)
  end

  it 'has a source field' do
    expect(Recipe.new).to respond_to(:source)
  end

  it 'has a usr_image field' do
    expect(Recipe.new).to respond_to(:url_image)
  end
end
