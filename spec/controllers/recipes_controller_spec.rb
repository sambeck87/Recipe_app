require 'rails_helper'

RSpec.describe RecipesController, type: :request do
  before do
    @first_user = User.create(name: 'sambeck', email: 'sambeck@outlook.com', encrypted_password: 'todoterreno')
    @second_user = User.create(name: 'Teofila', email: 'Teofila@outlook.com', encrypted_password: 'mascarita')
    @recipe = Recipe.create(name: 'sauce', preparation_time: 1, cooking_time: 1, description: 'my sauce recipe', public: true, user_id: @first_user.id)
    @food = Food.create(name: 'chilli', measurement_unit: 'piece', price: 1, user_id: @first_user.id)
    @recipe_food = RecipeFood.create(food_id: @food.id, recipe_id: @recipe.id)
    login_as @first_user
  end

  after do
    logout
  end

  describe 'GET #index' do
    before do
      get recipes_path
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'displays the index template' do
      expect(response).to render_template(:index)
    end

    it 'displays the correct recipe information' do
      expect(response.body).to include('sauce') # assuming recipe name is displayed
      expect(response.body).to include('my sauce recipe') # assuming recipe description is displayed
    end
  end
end
