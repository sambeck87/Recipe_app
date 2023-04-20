require 'rails_helper'

RSpec.describe FoodsController, type: :request do
  include Warden::Test::Helpers
  before do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
    @food = Food.create!(name: 'tomato', measurement_unit: 'piece', price: 0.4, quantity: 15, user_id: @first_user.id)
  end
  describe 'GET #index' do
    before do
      get foods_path
    end
    it 'should displays the index template' do
      expect(response).to render_template(:index)
    end
    it 'should displays the correct title' do
      expect(response.body).to include('Foods')
    end
    it 'should displays the foods name' do
      expect(response.body).to include('tomato')
    end
  end
  describe 'GET #new' do
    before do
      get new_food_path
    end
    it 'should displays the correct template' do
      expect(response).to render_template(:new)
    end
    it 'returns a successful response' do
      expect(response).to be_successful
    end
    it 'displays the correct title' do
      expect(response.body).to include('New food')
    end
    it 'displays the correct tags' do
      expect(response.body).to include('Name')
      expect(response.body).to include('Measurement unit')
      expect(response.body).to include('Price')
      expect(response.body).to include('Quantity')
      expect(response.body).to include('Create Food')
    end
  end
  describe 'GET #edit' do
    before do
      get edit_food_path(@food.id)
    end
    it 'should displays the correct template' do
      expect(response).to render_template(:edit)
    end
    it 'should returns a successful response' do
      expect(response).to be_successful
    end
    it 'should displays the correct title' do
      expect(response.body).to include('Editing food')
    end
    it 'should displays the Update Food button' do
      expect(response.body).to include('Update Food')
    end
  end
  describe 'DELETE #destroy' do
    before do
      delete food_path(@food)
    end
    it 'should returns a successful response' do
      expect(response).to redirect_to(foods_url)
      expect(flash[:notice]).to eq('Food was successfully destroyed.')
    end
  end
end
