class PublicRecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @recipes = Recipe.includes(:user, recipe_foods: :food).where(public: true).order(created_at: :desc)
      .map do |recipe|
      {
        recipe_id: recipe.id,
        recipe_name: recipe.name,
        food_list: recipe.recipe_foods.map do |recipe_food|
          {
            food_name: recipe_food.food.name,
            quantity: recipe_food.quantity
          }
        end,
        total_price: recipe.recipe_foods.sum { |recipe_food| recipe_food.food.price * recipe_food.quantity },
        user_name: recipe.user.name
      }
    end
  end

  def show
    @recipe = Recipe.includes(:user).find(params[:id])
    @recipe_foods = RecipeFood.includes(:food).where(recipe_id: @recipe.id)
  end
end
