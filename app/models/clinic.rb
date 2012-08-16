class Clinic < ActiveRecord::Base
  has_many :datapoints
  has_many :scores
  has_many :reviews
  has_many :requests
  has_many :users
  
  default_scope :order => 'state ASC'
  
  def to_param
    "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end
  
  
	before_save :create_permalink
  
  def self.search(search)
    like_operator = "LIKE"
    if Rails.env.production?
      like_operator = "ILIKE"
    else
      like_operator = "LIKE"
    end
    if search
      state = State.where('name LIKE ?', "%#{search}%")
      if !state.empty?
        Clinic.where("clinic_name #{like_operator} ? OR city #{like_operator} ? OR state #{like_operator} ? OR practice_director #{like_operator} ?", "%#{search}%", "%#{search}%", "%#{state.first.abbrev}%", "%#{search}%").order("clinic_name").all
      else
        Clinic.where("clinic_name #{like_operator} ? OR city #{like_operator} ? OR state #{like_operator} ? OR practice_director #{like_operator} ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").order("clinic_name").all
      end
    else
      Clinic.order("clinic_name").all
    end
  end
  
  private
		def create_permalink
			self.permalink = "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
		end
end
