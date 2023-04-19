class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy]

  # GET /recipes or /recipes.json
  def index
    @recipes = current_user.recipes.order(created_at: :desc)
  end

  def public_recipe
    @recipes = Recipe.includes(:user, recipe_foods: :food).where(public: true)
      .map do |recipe|
      {
        recipe_name: recipe.name,
        food_list: recipe.recipe_foods.map do |recipe_food|
          {
            food_name: recipe_food.food.name,
            quantity: recipe_food.quantity,
            required: recipe_food.required
          }
        end,
        total_price: recipe.recipe_foods.sum { |recipe_food| recipe_food.food.price * recipe_food.quantity },
        user_name: recipe.user.name
      }
    end
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit; end

  def make_private
    @recipe = Recipe.find(params[:id])
    @recipe.update_attribute(:public, !@recipe.public)
    redirect_to recipe_path(@recipe)
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
