class RecipeFoodsController < ApplicationController
  before_action :set_recipe_food, only: %i[show edit update destroy]

  # GET /recipe_foods or /recipe_foods.json
  def index
    @recipe_foods = RecipeFood.all
    @foods = Food.where(user_id: current_user.id).order(:name)
    @recipe = Recipe.find(params[:recipe_id])
  end

  def new
    @recipe_food = RecipeFood.new
  end

  def create
    @recipe_food = RecipeFood.new(recipe_food_params)

    respond_to do |format|
      if @recipe_food.save
        format.html do
          redirect_to recipe_recipe_foods_path(params[:recipe_id]), notice: 'Recipe food was successfully created.'
        end
        format.json { render :show, status: :created, location: @recipe_food }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe_food.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recipe_food.update(recipe_food_params)
        format.html { redirect_to recipe_food_url(@recipe_food), notice: 'Recipe food was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe_food }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe_food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipe_foods/1 or /recipe_foods/1.json
  def destroy
    @recipe_food.destroy

    respond_to do |format|
      format.html do
        redirect_back(fallback_location: recipe_recipe_foods_path(params[:recipe_id]),
                      notice: 'Recipe food was successfully destroyed.')
      end
      format.json { head :no_content }
    end
  end

  def increment_quantity
    @recipe_food = RecipeFood.find(params[:id])
    @recipe_food.quantity += 1
    @recipe_food.save
    redirect_back(fallback_location: recipe_recipe_foods_path(params[:recipe_id]))
  end

  def decrement_quantity
    @recipe_food = RecipeFood.find(params[:id])
    @recipe_food.quantity -= 1
    @recipe_food.save
    redirect_back(fallback_location: recipe_recipe_foods_path(params[:recipe_id]))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe_food
    @recipe_food = RecipeFood.find(params[:id])
  end

  def recipe_food_params
    params.permit(:quantity, :food_id, :recipe_id)
  end
end
