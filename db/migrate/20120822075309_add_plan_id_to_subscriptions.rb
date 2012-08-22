class AddPlanIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :plan_id, :integer
    add_column :subscriptions, :stripe_customer_token, :string
  end
end
