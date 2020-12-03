class ChangePurchaseDateAndExpireDateToBeDate < ActiveRecord::Migration[6.0]
  def change
    change_column :foods, :purchase_date, :date
    change_column :foods, :expire_date, :date
  end
end
