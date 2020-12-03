class AddExpireDateToFoods < ActiveRecord::Migration[6.0]
  def change
    add_column :foods, :expire_date, :datetime
  end
end
