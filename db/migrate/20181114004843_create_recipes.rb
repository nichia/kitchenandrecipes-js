class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.string :prep_time
      t.string :cook_time
      t.string :yield
      t.string :yield_size
      t.boolean :private, default: false
      t.integer :source
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
