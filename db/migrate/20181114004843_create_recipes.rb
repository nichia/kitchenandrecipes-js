class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.time :prep_time
      t.time :cook_time
      t.string :yields
      t.string :yields_size
      t.boolean :private, default: false
      t.integer :source
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
