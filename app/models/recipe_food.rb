class RecipeFood < ApplicationRecord
  belongs_to :food
  belongs_to :recipe

  def increment_quantity
    self.quantity += 1
  end
end
