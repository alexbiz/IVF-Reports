require 'csv'

namespace :db do
  desc "Fill database with Admin Account."
  task :add_admins => :environment do
	
	  #create administrative user
	  admin = User.create!(:email => "alex@alx.bz",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin_account)
    
    user_admin = admin.build_admin(
                                 :first_name => 'Alex',
                                  :last_name => 'Bisignano',
                                  :title => 'Minister of Technology')
    admin.save!
    puts "Added admin: #{user_admin.title}"
      
    admin2 = User.create!(  :email => 'jc@embryos.net',
                            :password => "foobar",
                            :password_confirmation => "foobar"
    )
	  admin2.toggle!(:admin_account)
	
	  
    user_admin2 = admin2.build_admin(  
                                 :first_name => 'Jacques',
                                  :last_name => 'Cohen',
                                  :title => 'Minister of Science')
    admin2.save!                                
    puts "Added admin: #{user_admin2.title}"                                  
  end
end