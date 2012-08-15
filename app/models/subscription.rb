class Subscription < ActiveRecord::Base
  belongs_to :user
  attr_accessible :card, :description, :product, :user_id
end
