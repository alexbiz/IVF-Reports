require 'csv'

namespace :db do
  desc "Fill database with clinic data from 2005."
  task :export_clinic_awards => :environment do
    #need to import the chromosome CSV file here...
    #Will import the clinic data from 2005
    path = "#{::Rails.root}/lib/tasks/data/clinic_demo_data.csv"
    clinics = Clinic.all
	  CSV.open(path, "wb", :col_sep => ',') do |row|
	    row << ["Clinic Name", "Address", "City", "State", "Zip", "Phone", "Practice Director", "Medical Director", "Lab Director", "Website", "2010 Cycles", "Awards"]
	    clinics.each do |c|
	      total_cycles = 0
	      c.datapoints.where(:year => 2010, :diagnosis => "All Diagnoses", :cycle_type => "fresh", :age_group => "All Ages").each do |d|
	        puts "Adding cycle data: #{d.cycles}"
	        total_cycles += d.cycles
        end
        row << [c.clinic_name, c.address, c.city, c.state, c.zip, c.phone, c.practice_director, c.laboratory_director, c.medical_director, c.website, total_cycles, c.awards(CURRENT_YEAR)]
        puts "Writing datapoint Clinic: #{c.clinic_name}."
      end
    end
  end
end