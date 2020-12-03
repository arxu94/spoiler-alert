class RemoveShelfLifeFromFoods < ActiveRecord::Migration[6.0]
  def change
    remove_column :foods, :shelf_life, :string
  end
end
