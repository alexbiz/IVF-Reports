class Patient < ActiveRecord::Base
  belongs_to :user
  has_many :requests
  has_many :reviews
  attr_accessible :username, :about, :address, :birthday, :city, :ethnicity, :first_name, :gender, :infertility_diagnosis, :last_name, :permalink, :phone, :previous_cycles, :state, :zip_code, :zip_distance
  
  username_regex = /^[A-Za-z\d_]+$/
	
	validates :username,	:presence => true,
						        :length => { :maximum => 50 },
						        :format => { :with => username_regex },
						        :uniqueness => { :case_sensitive => false }
  before_save :create_permalink

	def to_param
		permalink
	end
	
	private
	
  	def create_permalink
  		self.permalink = username.downcase
  	end
  	
end
