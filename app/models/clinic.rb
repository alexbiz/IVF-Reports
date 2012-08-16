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
    if search
      state = State.where('name LIKE ?', "%#{search}%")
      if !state.empty?
        Clinic.where('clinic_name LIKE ? OR city LIKE ? OR state LIKE ? OR practice_director LIKE ?', "%#{search}%", "%#{search}%", "%#{state.first.abbrev}%", "%#{search}%").order("name")all
      else
        Clinic.where('clinic_name LIKE ? OR city LIKE ? OR state LIKE ? OR practice_director LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").order("name").all
      end
    else
      Clinic.all
    end
  end
  
  private
		def create_permalink
			self.permalink = "#{id}-#{clinic_name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
		end
end
