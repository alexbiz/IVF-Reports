class User < ActiveRecord::Base
  has_one :admin, :dependent => :destroy
  has_one :professional, :dependent => :destroy
  has_one :patient, :dependent => :destroy
  has_many :subscriptions
  belongs_to :clinic

	attr_accessor :password
	attr_accessible :email, :password, :password_confirmation, :professional_account, :patient_account, :clinic_account, :admin_account
	
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email,	:presence => true, 
						        :format => { :with => email_regex }, 
						        :uniqueness => { :case_sensitive => false }
						
	validates :password, 	:presence => true,
							          :confirmation => true,
							          :length => {:within => 6..40},
							          :on => :create
							          
	validates :password,  :confirmation => true,
	                      :on => :update
	
	
	before_save :encrypt_password, :unless => "password.blank?" || "confirmation.blank?" || "password.length==0"
  
	
	
	
	#Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)#compare encrypted_password with the version in db
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	
	private
	
		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
		
end
