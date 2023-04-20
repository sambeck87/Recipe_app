require 'rails_helper'

RSpec.describe 'Food', type: :feature do
  include Warden::Test::Helpers
  before :each do
    @first_user = User.create!(name: 'test', email: 'test@gmail.com', password: 'test12')
    login_as(@first_user, scope: :user)

    @food1 = Food.create(name: 'butter', measurement_unit: 'lb', price: 1.3, quantity: 3, user: @first_user)
    @food2 = Food.create(name: 'cocoa', measurement_unit: 'spoon', price: 0.1, quantity: 100, user: @first_user)
    @food3 = Food.create(name: 'egg', measurement_unit: 'piece', price: 0.5, quantity: 15, user: @first_user)

    visit foods_path
    @foods_url = foods_path(@food1.id)
  end

  context 'The page should display list Foods' do
    it 'should display the Food name' do
      expect(page).to have_content('butter')
      expect(page).to have_content('cocoa')
      expect(page).to have_content('egg')
    end
  end

  context 'The show link should redirect to the food Edit page' do
    it 'Redirect to correct links' do
      first_link = page.all(:link, 'Edit')[0] # Obtener el segundo link
      click_link(href: first_link['href'])
      expect(current_path) == @foods_url
    end

    it 'When I click on the second Edit, should redicret to edit for second user' do
      second_link = page.all(:link, 'Edit')[1] # Obtener el segundo link
      click_link(href: second_link['href'])
      expect(current_path) == @foods_url
    end

    context 'Test Food list should contain delete button' do
      it 'There should contain 3 Delete button' do
        buttons = page.all(:button, 'Delete')
        expect(buttons.length).to eq(3)
      end
    end

    context 'Test Food list should contain button button for new food' do
      it 'There should contain button for adding new food' do
        expect(page).to have_content('New food')
      end
      it 'New Button should redirect to correct page' do
        new_food_link = page.all(:link, 'New food')[0]
        click_link(href: new_food_link['href'])
        expect(current_path) == new_food_path
      end
    end
  end
end
