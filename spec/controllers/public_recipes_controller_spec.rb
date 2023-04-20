require 'rails_helper'

RSpec.describe PublicRecipesController, type: :request do
  include Warden::Test::Helpers
  before do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
    @recipe = Recipe.create!(name: 'New recipe', preparation_time: 1, cooking_time: 1, description: 'My sauce recipe',
                             public: true, user: @first_user)
    @private_recipe = Recipe.create!(name: 'private recipe', preparation_time: 2, cooking_time: 2,
                                     description: 'My private sauce recipe',
                                     public: false, user: @first_user)
    @food = Food.create!(name: 'chilli', measurement_unit: 'piece', price: 1, user_id: @first_user.id)
    @recipe_food = RecipeFood.create!(food_id: @food.id, recipe_id: @recipe.id)
  end
  describe 'GET #index' do
    before do
      get public_recipes_path
    end
    it 'returns a successful response' do
      expect(response).to be_successful
    end
    it 'displays the index template' do
      expect(response).to render_template(:index)
    end
    it 'displays the correct title' do
      expect(response.body).to include('Public Recipe')
    end
    it 'displays only the public recipes' do
      expect(response.body).to include('New recipe')
      expect(response.body).not_to include('private recipe')
    end
  end
  describe 'GET #show' do
    before do
      get public_recipe_path(@recipe.id)
    end
    it 'returns a successful response' do
      expect(response).to be_successful
    end
    it 'displays the index template' do
      expect(response).to render_template(:show)
    end
    it 'displays the name of the recipe' do
      expect(response.body).to include('New recipe')
    end
    it 'displays the recipe description' do
      expect(response.body).to include('My sauce recipe')
    end
    it 'displays the ingredients' do
      expect(response.body).to include('chilli')
    end
  end
end
