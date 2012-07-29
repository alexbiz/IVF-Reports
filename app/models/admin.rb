class Admin < ActiveRecord::Base
  belongs_to :user
  attr_accessible :first_name, :last_name, :title
end
