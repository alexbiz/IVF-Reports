require 'csv'

namespace :db do
  desc "Add the ranking data for 2009."
  task :clinic_difficulty_analysis => :environment do
    #This needs to, for each year, determine the national average statistics...
    #The national_average will be identified by a clinic_id of 9999
	  path = "#{::Rails.root}/lib/tasks/data/selection_analysis.csv"
	  CSV.open(path, "wb", :col_sep => ',') do |row|
	    row << ["Clinic ID", "Year", "Age Group", "Diagnosis", "Expected Implantation Rate Z-Score", "Actual Implantation Rate Z-Score", "Average Number of Embryos Trx", "Cycles"]
  	  years = [2005, 2006, 2007, 2008, 2009, 2010]
  	  age_groups = ["<35","35-37","38-40","41-42",">42", "All Ages"]
  	  diagnoses = ["All Diagnoses", "Endometriosis", "Diminished Ovarian Reserve", "Multiple Female Factors", "Ovulatory Dysfunction", "Tubal Factor", "Female and Male Factors", "Male Factor", "Other Factor", "Unknown Factor", "Uterine Factor"]
  	  clinics = Clinic.all
	    national_clinic = Clinic.find_by_id(384)  	  
  	  cycles_minimum = 10
  	  year_index = 0 #Housekeeping for the year loop, but we should do a separate file for each year (moving forward we would only do one year at a time)
  	  while(year_index < 6)
  	      age_group_index = 0 #Housekeeping for the age-group loop
  	      while(age_group_index < 5)
            #For each important statistic, we need a weighted mean and weighted standard deviation
            #after this first loop through the data, we then want to assign Z-scores to each clinic for each statistic
            #Once Z-scores are done, we want to linearize the scores/weight them based on our bell curve on the 3rd loop
            #Denominators
            total_num_embryos = 0
            total_num_cycles = 0
          
            #means
            imp_mean = 0
            exp_imp_mean = 0
            birth_mean = 0
            avg_emb_mean = 0
          
            #Sums of squares of differences (for standard deviations)
            imp_ss = 0
            exp_imp_ss = 0
          
            #SDs
            imp_sd = 0
            exp_imp_sd = 0
          
            #Arrays with all the data
            clinic_ids = []
            cycles = []
            imp_rates = []
            exp_imp_rates = []
            avg_emb_rates = []
            
            #Weights for calculations
            imp_weights = []
            exp_imp_weights = []
          
            #Arrays with z-scores
            imp_z_scores = []
            exp_imp_z_scores = []
          
            #Final Scores
            imp_final_scores = []
            exp_imp_final_scores = []
          
            #Array needs to be collected with the relevant statistics
            array_index = 0

            
            clinics.each do |c|
              #We need a separate rake task for 'All Ages'
              puts "Analyzing Clinic #{c.id}."
              #Pull out datapoints and check if there is anything
              cur_datapoint = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => "All Diagnoses")
              unless cur_datapoint.empty?
                #We only want to include clinics with >= 10 cycles in the rankings (for individual age groups)
                unless cur_datapoint[0].cycles < cycles_minimum || cur_datapoint[0].clinic_id == 384
                  clinic_ids[array_index] = cur_datapoint[0].clinic_id
                  cycles[array_index] = cur_datapoint[0].cycles
                  imp_rates[array_index] = cur_datapoint[0].implantation_rate
                  exp_imp_rates[array_index] = 0
                  num_embryos = (cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred)
                
                  #NOTE WE NEED TO CALcULATE THE EXPECTED IMPLANTATION RATE HERE
                  diagnosis_index = 1 #Housekeeping for the diagnosis loop...do not include all Diagnoses
                  puts "Calculating Expected Implantation Rate for Clinic #{c.id}."
            	    while(diagnosis_index < 11)
            	      cur_datapoint_exp = c.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => diagnoses[diagnosis_index])
            	      national_datapoint = national_clinic.datapoints.where(:year => years[year_index], :age_group => age_groups[age_group_index], :diagnosis => diagnoses[diagnosis_index])
            	      unless cur_datapoint_exp.empty?
                      #We only want to include clinics with >= 10 cycles in the rankings (for individual age groups)
                      exp_cycles = cur_datapoint_exp[0].cycles
                      exp_avg_embs = cur_datapoint_exp[0].avg_num_embs_transferred
                      exp_tot_embs = exp_cycles * exp_avg_embs #Total number of embryos transferred in this diagnostic group
                      exp_emb_proportion = exp_tot_embs.to_f/num_embryos.to_f
                      exp_imp_rates[array_index] += exp_emb_proportion.to_f*national_datapoint[0].implantation_rate
                    end
                    diagnosis_index += 1
              	  end #end of the diagnosis while loop
                  avg_emb_rates[array_index] = cur_datapoint[0].avg_num_embs_transferred                  
                
                  total_num_cycles += cur_datapoint[0].cycles
                  total_num_embryos += (cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred)
                  
                  imp_weights[array_index] = cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred*cur_datapoint[0].implantation_rate
                  exp_imp_weights[array_index] = cur_datapoint[0].cycles*cur_datapoint[0].avg_num_embs_transferred*exp_imp_rates[array_index]
                  
                  array_index += 1
                end #unless cycles < 10
              end #unless cur_datapoint is empty
            
            end #End of the clinics.each loop

            if(array_index==0) #If no Clinics have > 10 cycles for this category...SKIP
            
            else
              #Now cacluate the means
              imp_mean = imp_weights.sum/total_num_embryos
              exp_imp_mean = exp_imp_weights.sum/total_num_embryos
          
              puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]}  | Implantation Mean: #{imp_mean}."
              puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]}  | Expected Implantation Mean: #{exp_imp_mean}."
          
              #Now we need the length of the array (array_index), and we need to loop through the array to calculate the sums of the squares of differences, and divide by the total number of datapoints minus 1
              calculation_index = 0
              while(calculation_index < array_index)
                imp_ss += ((imp_rates[calculation_index] - imp_mean)**2)*cycles[calculation_index]*avg_emb_rates[calculation_index] #This value eventually has to be divided by the total number of embryos
                exp_imp_ss += ((exp_imp_rates[calculation_index] - exp_imp_mean)**2)*cycles[calculation_index]*avg_emb_rates[calculation_index] #This value eventually has to be divided by the total number of embryos
                calculation_index += 1
              end
          
              #calculate the standard deviations
              imp_sd = Math.sqrt(imp_ss/total_num_embryos)
              exp_imp_sd = Math.sqrt(exp_imp_ss/total_num_embryos)
          
          
              puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} | Implantation SD: #{imp_sd}."
              puts "Year: #{years[year_index]} Age Group: #{age_groups[age_group_index]} | Expected Implantation SD: #{exp_imp_sd}."
          
              #Next we need to loop through the data again to assign Z-scores based on the means and SDs 
              z_calc_index = 0
              while(z_calc_index < array_index)
                if(imp_sd==0)
                  imp_z_scores[z_calc_index] = 0.0
                else
                  imp_z_scores[z_calc_index] = (imp_rates[z_calc_index].to_f - imp_mean.to_f)/imp_sd.to_f
                end
            
                if(exp_imp_sd==0)
                  exp_imp_z_scores[z_calc_index] = 0.0
                else
                  exp_imp_z_scores[z_calc_index] = (exp_imp_rates[z_calc_index].to_f - exp_imp_mean.to_f)/exp_imp_sd.to_f
                end     
              
                #Now we can print to our CSV
                row << ["#{clinic_ids[z_calc_index]}", "#{years[year_index]}", "#{age_groups[age_group_index]}", "All Diagnoses", "#{imp_z_scores[z_calc_index]}", "#{exp_imp_z_scores[z_calc_index]}", "#{avg_emb_rates[z_calc_index]}", "#{cycles[z_calc_index]}"]
                puts "Printed Z-Scores for: Clinic ID: #{clinic_ids[z_calc_index]}, Age Group: #{age_groups[age_group_index]}."
              
                z_calc_index += 1
              end
            
                #Now insert the score into the database!
                #Here the variables need to be inserted into the database        
                #Score.create!(	
                #	:clinic_id => clinic_ids[score_calc_index],
                #	:age_group => age_groups[age_group_index],
                #	:year => years[year_index],
                #	:diagnosis => diagnoses[diagnosis_index],
                #	:cycle_type => "fresh",
                #	:ivf_reports_score => ivf_reports_final_scores[score_calc_index],
                #	:quality_score => imp_final_scores[score_calc_index],
                #	:safety_score => avg_emb_final_scores[score_calc_index],
              	# :sart_score => birth_final_scores[score_calc_index]
                #)
              
            end #End if array_index == 0 if statement
            age_group_index += 1
          end #end of the age group while loop

  	    year_index += 1
      end #end of the year while loop
    
      puts "Rake ran without errors."
    end #End of CSV do
  end
end