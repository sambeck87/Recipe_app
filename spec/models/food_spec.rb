require 'rails_helper'

RSpec.describe Food, type: :model do
  subject do
    @user = User.new(name: 'sambeck', email: 'sambeck@outlook.com', encrypted_password: 'todoterreno')
    Food.new(name: 'tomato', measurement_unit: 'piece', price: 0.4, quantity: 15, user_id: @user.id)
  end
  before { subject.save }
  context 'User should create a Food with name "tomato"' do
    it 'should have a name attribute present' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
    it 'name should be "tomato"' do
      expect(subject.name).to eq('tomato')
    end
  end
  context 'The quantity shoul be correct' do
    it 'The quantity should be 15' do
      expect(subject.quantity).to eq(15)
    end
  end
  context 'The measurement unit should be correct' do
    it 'The measurement unit should be' do
      expect(subject.measurement_unit).to eq('piece')
    end
  end
end
