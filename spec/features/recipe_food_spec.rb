require 'rails_helper'

RSpec.describe 'Recipes', type: :feature do
  include Warden::Test::Helpers
  before :each do
    @first_user = User.create!(name: 'sambeck', email: 'sambeck@outlook.com', password: 'todoterreno')
    login_as(@first_user, scope: :user)
    @recipe = Recipe.create!(name: 'My new recipe', preparation_time: 1, cooking_time: 1, description: 'My sauce recipe', public: true, user: @first_user)
    @food1 = Food.create!(name: 'butter', measurement_unit: 'lb', price: 1.3, quantity: 3, user: @first_user)
    @food2 = Food.create!(name: 'cocoa', measurement_unit: 'spoon', price: 0.1, quantity: 100, user: @first_user)
    @food3 = Food.create!(name: 'egg', measurement_unit: 'piece', price: 0.5, quantity: 15, user: @first_user)

    visit "#{recipes_path}/#{@recipe.id}/recipe_foods"
    @recipe1_url = "#{recipes_path}/#{@recipe.id}"
  end

  context 'The page should be displayed correctly' do
    it 'should display the correct title page' do
      expect(page).to have_content('Recipe foods')
    end

    it 'should display the list of ingredients' do
      expect(page).to have_content('butter')
      expect(page).to have_content('cocoa')
      expect(page).to have_content('egg')
    end

    it 'should display the Add button' do
      expect(page).to have_content('Add')
    end
  end

  context 'Testing the Add button' do
    it 'should not display the increment (+) and decrement (-) buttons' do
      expect(page).not_to have_content('+')
      expect(page).not_to have_content('-')
    end
    it 'should display the incremetn and decrement buttons' do
      first('.btn-primary').click
      expect(page).to have_content('+')
      expect(page).to have_content('-')
    end

    it 'should not exist recipe_foods' do
      expect(RecipeFood.all.length).to eq(0)
    end

    it 'should exist one recipe_foods' do
      first('.btn-primary').click
      expect(RecipeFood.all.length).to eq(1)
    end
  end

  describe 'Testing increment and decrement buttons' do
    before :each do
      first('.btn-primary').click
      @recipe_food = RecipeFood.all.first
    end

    context 'Test increment button' do
      it 'the quantity should be "1"' do
        expect(@recipe_food.quantity).to eq(1)
        expect(page).to have_content(1)
        expect(page).not_to have_content(3)
      end

      it 'The quantity should be "3" after push the increment button(+) twice' do
          click_button '+'
          click_button '+'
        expect(page).to have_content(3)
      end
    end
    context 'Test decrement button' do
      it 'The quantity should be "4" after push the increment button(+) 6 time and push the decrement button 3 times' do
        6.times do
          click_button '+'
        end
        expect(page).to have_content(7)
        3.times do
          click_button '-'
        end
        expect(page).to have_content(4)
      end
    end

    context 'Testing the Done button' do
      it 'should redirect to the recipe page' do
        click_link 'Done'
        expect(current_path).to eq(@recipe1_url)
      end

      it 'should display only the ingredient added' do
        click_link 'Done'
        expect(page).to have_content('butter')
        expect(page).not_to have_content('cocoa')
        expect(page).not_to have_content('egg')
      end
    end
  end
end
