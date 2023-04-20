class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.decimal :preparation_time
      t.decimal :cooking_time
      t.text :description
      t.boolean :public, default:false
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
