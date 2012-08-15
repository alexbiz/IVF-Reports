class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string :description
      t.string :product
      t.string :card

      t.timestamps
    end
  end
end
