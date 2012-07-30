require 'csv'

namespace :db do
  desc "Fill database with state data."
  task :add_state_data => :environment do
    #need to import the chromosome CSV file here...
    #Will import the cliic data from 2005
	  CSV.foreach("#{::Rails.root}/lib/tasks/data/state_data.csv") do |row|
		  cur_state = State.find_by_abbrev("#{row[1]}")
      if(cur_state.nil?)
	
		    State.create!(	
						:name => row[0],
						:abbrev => row[1],
						:population => row[2],
						:capital => row[3]
            )
      
        puts "Just added state: #{row[0]} | #{row[1]}"
            
      
      end
    end
  end
end