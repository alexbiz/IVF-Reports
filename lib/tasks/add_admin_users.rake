require 'csv'

namespace :db do
  desc "Fill database with Admin Account."
  task :add_admin_users => :environment do
	
	  #create administrative user
	  admin = User.create!(:name => "alexbiz",
                         :email => "alex@alx.bz",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin_account)
      
    admin2 = User.create!(  :name => "ivfreports",
                            :email => 'info@ivfreports.org',
                            :password => "foobar",
                            :password_confirmation => "foobar"
    )
	  admin2.toggle!(:admin_account)
	
  end
end