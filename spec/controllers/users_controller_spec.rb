require 'rails_helper'

RSpec.describe UsersController, type: :request do
    before do
    @first_user = User.create(name: 'sambeck', email: 'sambeck@outlook.com', encrypted_password: 'todoterreno')
    @second_user = User.create(name: 'Teofila', email: 'Teofila@outlook.com', encrypted_password: 'mascarita')
    @recipe = Recipe.create(name: 'sauce', preparation_time: 1, cooking_time: 1, description: 'my sauce recipe', public: true, user_id: @user.id)
    @food = Food.create(name: 'chilli', measurement_unit: "piece", price: 1, user_id: @user.id)
    @recipe_food = RecipeFood.create(food_id: @food.id, recipe_id: @recipe.id)
  end

  describe 'GET #index' do
    before do
      get users_path(@first_user)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'displays the correct template and content' do
      expect(response).to render_template(:index)
    end
  end

end
