class AddImageToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :image, :text
  end
end