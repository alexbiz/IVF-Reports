class Subscription < ActiveRecord::Base
  belongs_to :user
  attr_accessor :stripe_card_token
  attr_accessible :card, :description, :product, :user_id, :plan_id, :stripe_card_token
  
  validates :user_id,	:presence => true
  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(:description => "#{description} registered for a premium provider account.", :email => description, :plan => plan_id, :card => stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error whilte creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
