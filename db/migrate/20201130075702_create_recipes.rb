class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :ingredient
      t.string :instructions
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end