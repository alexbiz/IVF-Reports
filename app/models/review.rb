class Review < ActiveRecord::Base
  belongs_to :patient
  belongs_to :clinic
  
  default_scope :order => 'created_at DESC'
end
