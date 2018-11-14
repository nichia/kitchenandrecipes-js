require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'has a rating field' do
    expect(Review.new).to respond_to(:rating)
  end

  it 'has a comment field' do
    expect(Review.new).to respond_to(:comment)
  end
end
