class PagesController < ApplicationController
  def home
    @user = User.new
  end
  
  def lead_contact
    @title = "Step 2 - Contact Your Best Clinics"
    
	  @age_group = "All Ages"
	  @diagnosis = "All Diagnoses"
	  cycle_type = "fresh"
	  @year = "2010"
	  zip_distance = 100

	  if(params[:birthday].nil?)
	    user_age = 0
    else
      user_age = ((Date.today) - Date.new(params[:birthday]["(1i)"].to_i, params[:birthday]["(2i)"].to_i, params[:birthday]["(3i)"].to_i)).to_i/365
    end
    
    if(params[:infertility_diagnosis].nil?)
      @diagnosis = "All Diagnoses"
	  elsif(params[:infertility_diagnosis]=="endometriosis")
	    @diagnosis = "Endometriosis"
	  elsif(params[:infertility_diagnosis]=="diminished_ovarian_reserve")
	    @diagnosis = "Diminished Ovarian Reserve"
	  elsif(params[:infertility_diagnosis]=="multiple_female_factors")
	    @diagnosis = "Multiple Female Factors"
	  elsif(params[:infertility_diagnosis]=="ovulatory_dysfunction")
	    @diagnosis = "Ovulatory Dysfunction"
	  elsif(params[:infertility_diagnosis]=="tubal_factor")
	    @diagnosis = "Tubal Factor"
	  elsif(params[:infertility_diagnosis]=="female_and_male_factors")
	    @diagnosis = "Female and Male Factors"
	  elsif(params[:infertility_diagnosis]=="male_factor")
	    @diagnosis = "Male Factor"
	  elsif(params[:infertility_diagnosis]=="other_factor")
	    @diagnosis = "Other Factor"
	  elsif(params[:infertility_diagnosis]=="uterine_factor")
	    @diagnosis = "Uterine Factor"
	  elsif(params[:infertility_diagnosis]=="unknown_factor")
	    @diagnosis = "All Diagnoses"
	  else
	    @diagnosis = "All Diagnoses"
    end
	  
	  if(user_age < 35)
	    @age_group = "<35"
    elsif(user_age >= 35 && user_age <= 37)
      @age_group = "35-37"
    elsif(user_age >= 38 && user_age <= 40)
      @age_group = "38-40"
    elsif(user_age >= 41 && user_age <= 42)
      @age_group = "41-42"
    else
	    @age_group = ">42"
	  end
	  
	  unless params[:zip_code].nil?
	    @coordinates = Geocoder.search(params[:zip_code])
	    @address = "City, State"
	    
	    while (@coordinates.nil?)
	      @coordinates = Geocoder.search(params[:zip_code])
      end
      
      if (@coodrinates.nil?)
        @coordinates[0].latitude = 37.769
        @coordinates[0].longituded = -97.211
      else
        @address = "#{@coordinates[0].city}, #{@coordinates[0].state_code}"
      end
    end
    
    if @coordinates.nil? || @coordinates.empty?
      @scores = Score.where(:year => @year, :cycle_type => cycle_type, :diagnosis => @diagnosis, :age_group => @age_group).limit(6).offset(0)

  	  if(@scores.empty?)
  	    diagnosis = "All Diagnoses"
  	    @scores = Score.where(:year => @year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => @age_group).limit(6).offset(0)
      end
    else #If there is a zip code for the user and coordinates are produced
      lat_offset = 1.5
      long_offset = 1.5
      
    	lat = @coordinates[0].latitude
    	low_lat = lat - lat_offset
    	high_lat = lat + lat_offset
    	long = @coordinates[0].longitude
    	low_long = long - long_offset
    	high_long = long + long_offset
      @scores = Score.where(:year => @year, :cycle_type => cycle_type, :diagnosis => @diagnosis, :age_group => @age_group).joins(:clinic).where(:clinics => {:latitude => low_lat..high_lat, :longitude => low_long..high_long}).limit(6).offset(0)

  	  if(@scores.empty?)
  	    diagnosis = "All Diagnoses"
  	    @scores = Score.where(:year => @year, :cycle_type => cycle_type, :diagnosis => @diagnosis, :age_group => @age_group).joins(:clinic).where(:clinics => {:latitude => low_lat..high_lat, :longitude => low_long..high_long}).limit(6).offset(0)
      end
  	end
	  

    
	  @clinic_results = Array.new;
    unless @scores.empty?
      result_count = 0
      @scores.each do |s|
        if(s.clinic_id==384)
          
        else
          unless result_count >= 5
            cur_clinic = Clinic.find_by_id(s.clinic_id)
            cur_new_object = cur_new_object = {'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => cur_clinic.id, 'clinic_name' => cur_clinic.clinic_name, 'permalink' => cur_clinic.permalink, 'city' => cur_clinic.city, 'state' => cur_clinic.state, 'address' => cur_clinic.address, 'practice_director' => cur_clinic.practice_director, 'lab_director' => cur_clinic.laboratory_director, 'medical_director' => cur_clinic.medical_director, 'zip' => cur_clinic.zip}
            @clinic_results << cur_new_object
            result_count +=1
          end
        end
      end
    end
    
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end
  
  def about
    @title = "About Us"
  end

  def contact
    @title = "Contact Us"
  end
  
  def clinicfind
    @title = "Find a Clinic"
  	year = "2010"
  	age = "All Ages"
  	diagnosis = "All Diagnoses"
  	cycle_type = "fresh"
    @states = State.all.collect { |state| state.name }
  	
  	respond_to do |format|
  	  format.html {}
  	  format.json do 
  	    @scores = Score.where(:year => year, :age_group => age, :diagnosis => diagnosis, :cycle_type => cycle_type).joins(:clinic).where(:clinics => {:state => @states})
        @clinic_results = Array.new;
        @scores.each do |s|
          cur_new_object = {'updated_at' => s.updated_at, 'year' => s.year, 'age_group' => s.age_group, 'diagnosis' => s.diagnosis, 'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => s.clinic.id, 'clinic_name' => s.clinic.clinic_name, 'permalink' => s.clinic.permalink, 'city' => s.clinic.city, 'state' => s.clinic.state, 'address' => s.clinic.address, 'practice_director' => s.clinic.practice_director, 'lab_director' => s.clinic.laboratory_director, 'medical_director' => s.clinic.medical_director, 'zip' => s.clinic.zip, 'info' => s.clinic.info, 'latitude' => s.clinic.latitude, 'longitude' => s.clinic.longitude}
          @clinic_results << cur_new_object
        end
  	    render :json => @clinic_results.to_json()
	    end
	  end
  end
  
  def loadclinicdata
    
  end
  
  def system
    @title = "Our Ranking System"
  end
  
  def ranking
    @title = "IVF Clinic Rankings"
    year = '2010'
    age_group = 'All Ages'
    diagnosis = 'All Diagnoses'
    cycle_type = 'fresh'
    page = 0 #This is what page to start on
    @states = State.all

    
    unless(params[:year].nil?)
      year = params[:year]
    end
    unless(params[:age_group].nil?)
      age_group = params[:age_group]
    end
    unless(params[:diagnosis].nil?)
      diagnosis = params[:diagnosis]
    end
    unless(params[:cycle_type].nil?)
      cycle_type = params[:cycle_type]
    end
    unless(params[:page].nil?)
      page = params[:page]
    end
  
    states = params[:states]
    
    page=page.to_i
    
    results = 10 #The number of results per page    
    results_start = page*results    
    
    if params[:region]=="ALL"
      @scores = Score.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type).joins(:clinic).where(:clinics => {:state => states}).limit(results).offset(results_start)
    else
      region = "ALL" #this can be changed if we want to go back to the region based ranking.
      @scores = Score.where(:year => year, :age_group => age_group, :diagnosis => diagnosis, :cycle_type => cycle_type).joins(:clinic).where(:clinics => {:state => states}).limit(results).offset(results_start)
    end
    
    @clinic_results = Array.new;
    unless @scores.empty?
      @scores.each do |s|
        cur_new_object = {'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => s.clinic.id, 'clinic_name' => s.clinic.clinic_name, 'permalink' => s.clinic.permalink, 'city' => s.clinic.city, 'state' => s.clinic.state, 'address' => s.clinic.address, 'practice_director' => s.clinic.practice_director, 'lab_director' => s.clinic.laboratory_director, 'medical_director' => s.clinic.medical_director, 'zip' => s.clinic.zip}
        @clinic_results << cur_new_object
      end
    end
    
    respond_to do |format|
      format.html {}
      format.json {render :json => @clinic_results.to_json()}
    end
  end
  
  def faqs
    @title = "Frequently Asked Questions"
  end
  
  def terms
    @title = "Terms and Conditions"
  end
  
  def privacy
    @title = "Privacy Policy"
  end
  
  def clinicians
    @title = "Clinicians"
  end

end
