class Professional < ActiveRecord::Base
  belongs_to :user
  attr_accessible :profession, :username
end
