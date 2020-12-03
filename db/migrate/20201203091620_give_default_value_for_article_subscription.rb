class GiveDefaultValueForArticleSubscription < ActiveRecord::Migration[6.0]
  def change
    change_column :foods, :status, :boolean, default: "false"
  end
end
