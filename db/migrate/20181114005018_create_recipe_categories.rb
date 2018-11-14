class CreateRecipeCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_categories do |t|
      t.references :recipe, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
