class AddColumnCookingTimeToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :cooking_time, :string
  end
end
