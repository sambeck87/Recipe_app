require 'rails_helper'

RSpec.describe Recipe, type: :model do
  subject do
    @user = User.new(name: 'sambeck', email: 'sambeck@outlook.com', encrypted_password: 'todoterreno')
    Recipe.new(name: 'sauce', preparation_time: 1, cooking_time: 1, description: 'my sauce recipe', public: true, user_id: @user.id)
  end

  before { subject.save }

  context 'User should create a user with name' do
    it 'should have a name attribute present' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'name should be "sauce"' do
      expect(subject.name).to eq('sauce')
    end
  end
  context 'Should have a description' do
    it 'description should be "my sauce recipe"' do
      expect(subject.description).to eq('my sauce recipe')
    end
  end

  context 'should be public' do
    it 'public should be true' do
      expect(subject.public).to eq(true)
    end
  end
end
