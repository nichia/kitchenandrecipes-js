require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it 'has a unit field' do
    expect(Measurement.new).to respond_to(:unit)
  end
end
