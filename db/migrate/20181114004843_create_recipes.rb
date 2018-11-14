class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.string :prep_time
      t.string :cook_time
      t.string :yield
      t.boolean :private, default: false
      t.integer :source
      t.string :url_image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
