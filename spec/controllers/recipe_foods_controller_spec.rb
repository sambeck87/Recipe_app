require 'rails_helper'

RSpec.describe RecipeFoodsController, type: :request do
  include Warden::Test::Helpers

  before do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
    @recipe = Recipe.create!(name: 'New recipe', preparation_time: 1, cooking_time: 1, description: 'My sauce recipe', public: true, user: @first_user)
    @food = Food.create!(name: 'chilli', measurement_unit: "piece", price: 1, user_id: @first_user.id)
    @recipe_food = RecipeFood.create!(food_id: @food.id, recipe_id: @recipe.id)
  end

  describe 'GET #index' do
    before do
      get recipe_recipe_foods_path(recipe_id: @recipe.id)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'displays the index template' do
      expect(response).to render_template(:index)
    end

    it 'displays the correct title' do
      expect(response.body).to include('Recipe foods')
    end

    it 'displays a list of created foods' do
      expect(response.body).to include('chilli')
    end
  end

  describe 'POST #create' do
    before do
      get recipe_recipe_foods_path(recipe_id: @recipe.id)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'PUT #increment_quantity' do
    before do
      put increment_quantity_recipe_recipe_food_path(@recipe_food.recipe_id, @recipe_food.id)
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'PUT #decrement_quantity' do
    before do
      put decrement_quantity_recipe_recipe_food_path(@recipe_food.recipe_id, @recipe_food.id)
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:redirect)
    end
  end

describe 'DELETE #destroy' do
  before do
    delete recipe_recipe_food_path(@recipe.id, @recipe_food.id)
  end

  it 'returns a successful response' do
    expect(response).to have_http_status(:redirect)
  end
end

end
