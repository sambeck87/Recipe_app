require 'rails_helper'

RSpec.describe RecipesController, type: :request do
  include Warden::Test::Helpers

  before do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
    @recipe = Recipe.create!(name: 'New recipe', preparation_time: 1, cooking_time: 1, description: 'My sauce recipe',
                             public: true, user: @first_user)
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

    it 'displays the correct recipe name' do
      expect(response.body).to include('New recipe')
      expect(response.body).to include('My sauce recipe')
    end

    it 'displays the correct recipe description' do
      expect(response.body).to include('My sauce recipe')
    end
  end

  describe 'GET #show' do
    before do
      get recipe_path(@recipe.id)
    end

    it 'displays the correct template' do
      expect(response).to render_template(:show)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'displays the correct recipe description' do
      expect(response.body).to include('My sauce recipe')
    end

    it 'displays all buttons' do
      expect(response.body).to include('Back to recipes')
      expect(response.body).to include('Add ingredient')
      expect(response.body).to include('Generate shopping list')
    end
  end

  describe 'GET #new' do
    before do
      get new_recipe_path
    end

    it 'displays the correct template' do
      expect(response).to render_template(:new)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'displays the correct title' do
      expect(response.body).to include('New recipe')
    end

    it 'displays the correct tags' do
      expect(response.body).to include('Name')
      expect(response.body).to include('Preparation time')
      expect(response.body).to include('Cooking time')
      expect(response.body).to include('Description')
      expect(response.body).to include('Public')
    end

    it 'displays all buttons' do
      expect(response.body).to include('Create Recipe')
    end
  end

  describe 'DELETE #destroy' do
    before do
      delete recipe_path(@recipe)
    end

    it 'returns a successful response' do
      expect(response).to redirect_to(recipes_url)
    end
    it 'should display the message "Recipe was successfully destroyed."' do
      expect(flash[:notice]).to eq('Recipe was successfully destroyed.')
    end
  end
end
