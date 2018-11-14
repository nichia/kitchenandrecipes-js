require 'rails_helper'

RSpec.describe Instruction, type: :model do
  it 'has a description field' do
    expect(Instruction.new).to respond_to(:description)
  end
end
