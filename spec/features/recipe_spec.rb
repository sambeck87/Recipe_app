require 'rails_helper'

RSpec.describe 'Recipes', type: :feature do
  include Warden::Test::Helpers
  before :each do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
    @recipe = Recipe.create!(name: 'My new recipe', preparation_time: 1, cooking_time: 1,
                             description: 'My sauce recipe', public: true, user: @first_user)
    @recipe2 = Recipe.create!(name: 'My last recipe', preparation_time: 2, cooking_time: 3,
                              description: 'My delicious recipe', public: true, user: @first_user)

    visit recipes_path
    @recipe1_url = "#{recipes_path}/#{@recipe.id}"
    @recipe2_url = "#{recipes_path}/#{@recipe2.id}"
    @form_url = "#{recipes_path}/new"
  end

  context 'The page should display the recipes' do
    it 'should display the recipe description' do
      expect(page).to have_content('My sauce recipe')
    end
  end

  context 'The recipes should be ordered from the last recipe created' do
    it 'The first recipe showed should be "My last recipe"' do
      expect(page.find('.card:eq(1)')).to have_content('My last recipe')
    end

    it 'The second recipe showed should be "My new recipe"' do
      expect(page.find('.card:eq(2)')).to have_content('My new recipe')
    end
  end

  context 'The show link should redirect to the recipe details page' do
    it 'When I click on the first Show this recipe, I am redirected to the first recipe details page' do
      first_link = page.all(:link, 'Show this recipe')[0] # Obtener el segundo link
      click_link(href: first_link['href'])
      expect(current_path) == @recipe1_url
    end

    it 'When I click on the second Show this recipe, I am redirected to the second recipe details page' do
      first_link = page.all(:link, 'Show this recipe')[1] # Obtener el segundo link
      click_link(href: first_link['href'])
      expect(current_path) == @recipe2_url
    end
  end

  context 'Test the New Recipe button' do
    it 'The New Recipe button should redirect to the add recipe form' do
      click_link 'New recipe'
      expect(current_path) == @form_url
    end
  end

  context 'Test Delete button' do
    it 'The first Delete nutton should delete the first recipe from the page' do
      first('.btn-danger').click
      expect(page).not_to have_content('My last recipe')
    end
  end

  describe 'Recipe' do
    before :each do
      visit "#{recipes_path}/#{@recipe2.id}"
      @add_ingredient_url = "#{recipes_path}/#{@recipe2.id}/recipe_foods"
    end

    context 'The details page should be desplayed' do
      it 'should display the name of the recipe "My last recipe"' do
        expect(page).to have_content('My last recipe')
      end

      it 'should display the preparation_time of the recipe' do
        expect(page).to have_content('Preparation time:')
        expect(page).to have_content('2.0 Hrs')
      end
    end

    context 'Test the public/private button' do
      it 'The public state should be true' do
        expect(@recipe2.public).to eq(true)
      end

      it 'The name of the button should be Public, not Private' do
        expect(page).to have_content('Public')
        expect(page).not_to have_content('Private')
      end

      it 'The public state should change when I click on the Public button' do
        click_button 'Public'
        expect(page).to have_content('Private')
        expect(@recipe2.public) == (false)
      end
    end

    context 'Test the Add ingredient button' do
      it 'The Add ingredient button should redirect to the add ingredient page' do
        click_button 'Add ingredient'
        expect(current_path).to eq(@add_ingredient_url)
      end
    end
    context 'Test the Back to recipes button' do
      it 'The Back to recipes button should redirect to the recipes page' do
        click_link 'Back to recipes'
        expect(current_path).to eq(recipes_path.to_s)
      end
    end
  end
end
