class AddPhotosToFoods < ActiveRecord::Migration[6.0]
  def change
    add_column :foods, :photo, :text
  end
end

