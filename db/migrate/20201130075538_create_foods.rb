class CreateFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.boolean :status
      t.datetime :purchase_date
      t.string :shelf_life
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
