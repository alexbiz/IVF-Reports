require 'csv'

namespace :db do
  desc "Fill database with clinic data from 2005."
  task :export_clinic_data => :environment do
    #need to import the chromosome CSV file here...
    #Will import the clinic data from 2005
    path = "#{::Rails.root}/lib/tasks/data/clinic_data.csv"
    clinics = Clinic.all
	  CSV.open(path, "wb", :col_sep => ',') do |row|
	    row << ["Clinic Name", "Address", "City", "State", "2010 Cycles (<35)", "Implantation Rate", "Avg Num Embs Trx", "Pregs per Cycle", "Births per Cycle", "Births per Retrieval", "Births per Transfer", "eSET Rate", "Twin Rate", "Triplet+ Rate"]
	    clinics.each do |c|
	      total_cycles = 0
	      c.datapoints.where(:year => '2010', :diagnosis => "All Diagnoses", :cycle_type => "fresh", :age_group => "All Ages").each do |d|
	        puts "Adding cycle data: #{d.cycles}"
	        total_cycles += d.cycles
	      c.datapoints.where(:year => 2010, :diagnosis => "All Diagnoses", :cycle_type => "fresh", :age_group => "<35").each do |d|	        
          row << [c.clinic_name, c.address, c.city, c.state, d.cycles, d.implantation_rate, d.avg_num_embs_transferred, d.pregs_per_cycle, d.births_per_cycle, d.births_per_retrieval, d.births_per_transfer, d.set_transfer_rate, d.twin_rate, d.trip_rate]
          puts "-----Writing datapoint: #{c.clinic_name}."
        end
      end
    end
  end
end