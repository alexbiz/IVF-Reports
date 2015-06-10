class Review < ActiveRecord::Base
  belongs_to :patient
  belongs_to :clinic
end
