class AddDiscountCodeToSubsriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :discount_code, :string
  end
end
