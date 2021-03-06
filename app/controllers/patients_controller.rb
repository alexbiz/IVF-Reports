class PatientsController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, 	:only => [:edit, :update]
  before_filter :admin_user, 	:only => :destroy
  
  def index
	  @title = "All Users"
	  @users = User.paginate(:page => params[:page])
  end
  
  def show
	  @patient = Patient.find_by_permalink(params[:id])
	  @user = @patient.user
	  @title = @patient.username
    
	  age_group = "All Ages"
	  diagnosis = "All Diagnoses"
	  cycle_type = "fresh"
	  year = "2010"

	  if(@patient.birthday.nil?)
	    user_age = 0
    else
      user_age = ((Date.today) - (@patient.birthday)).to_i/365
    end
    
    if(@patient.infertility_diagnosis.nil?)
      diagnosis = "All Diagnoses"
	  elsif(@patient.infertility_diagnosis=="endometriosis")
	    diagnosis = "Endometriosis"
	  elsif(@patient.infertility_diagnosis=="diminished_ovarian_reserve")
	    diagnosis = "Diminished Ovarian Reserve"
	  elsif(@patient.infertility_diagnosis=="multiple_female_factors")
	    diagnosis = "Multiple Female Factors"
	  elsif(@patient.infertility_diagnosis=="ovulatory_dysfunction")
	    diagnosis = "Ovulatory Dysfunction"
	  elsif(@patient.infertility_diagnosis=="tubal_factor")
	    diagnosis = "Tubal Factor"
	  elsif(@patient.infertility_diagnosis=="female_and_male_factors")
	    diagnosis = "Female and Male Factors"
	  elsif(@patient.infertility_diagnosis=="male_factor")
	    diagnosis = "Male Factor"
	  elsif(@patient.infertility_diagnosis=="other_factor")
	    diagnosis = "Other Factor"
	  elsif(@patient.infertility_diagnosis=="uterine_factor")
	    diagnosis = "Uterine Factor"
	  elsif(@patient.infertility_diagnosis=="unknown_factor")
	    diagnosis = "Unknown Factor"
	  else
	    diagnosis = "All Diagnoses"
    end
	  
	  if(user_age < 35)
	    age_group = "<35"
    elsif(user_age >= 35 && user_age <= 37)
      age_group = "35-37"
    elsif(user_age >= 38 && user_age <= 40)
      age_group = "38-40"
    elsif(user_age >= 41 && user_age <= 42)
      age_group = "41-42"
    else
	    age_group = ">42"
	  end
	  
	  unless @patient.zip_code.nil?
	    @coordinates = Geocoder.search(@patient.zip_code)
    end
    
    if @coordinates.nil? || @coordinates.empty?
      @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).limit(5).offset(0)

  	  if(@scores.empty?)
  	    diagnosis = "All Diagnoses"
  	    @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).limit(5).offset(0)
      end
    else #If there is a zip code for the user and coordinates are produced
      lat_offset = 1.5
      long_offset = 1.5
      
      if @patient.zip_distance=='25'
        lat_offset = 0.75
        long_offset = 0.75
      elsif @patient.zip_distance=='50'
        lat_offset = 1.5
        long_offset = 1.5
      elsif @patient.zip_distance=='100'
        lat_offset = 3.0
        long_offset = 3.0
      elsif @patient.zip_distance=='200'
        lat_offset = 6.0
        long_offset = 6.0
      elsif @patient.zip_distance=='ALL'
        lat_offset = 180.0
        long_offset = 180.0
      end
      
    	lat = @coordinates[0].latitude
    	low_lat = lat - lat_offset
    	high_lat = lat + lat_offset
    	long = @coordinates[0].longitude
    	low_long = long - long_offset
    	high_long = long + long_offset
      @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).joins(:clinic).where(:clinics => {:latitude => low_lat..high_lat, :longitude => low_long..high_long}).limit(5).offset(0)

  	  if(@scores.empty?)
  	    diagnosis = "All Diagnoses"
  	    @scores = Score.where(:year => year, :cycle_type => cycle_type, :diagnosis => diagnosis, :age_group => age_group).joins(:clinic).where(:clinics => {:latitude => low_lat..high_lat, :longitude => low_long..high_long}).limit(5).offset(0)
      end
  	end
	  

    
	  @clinic_results = Array.new;
    unless @scores.empty?
      @scores.each do |s|
        if(s.clinic_id==384)
          
        else
          cur_clinic = Clinic.find_by_id(s.clinic_id)
          cur_new_object = cur_new_object = {'ivf_reports_score' => s.ivf_reports_score, 'quality_score' => s.quality_score, 'safety_score' => s.safety_score, 'sart_score' => s.sart_score, 'clinic_id' => cur_clinic.id, 'clinic_name' => cur_clinic.clinic_name, 'permalink' => cur_clinic.permalink, 'city' => cur_clinic.city, 'state' => cur_clinic.state, 'address' => cur_clinic.address, 'practice_director' => cur_clinic.practice_director, 'lab_director' => cur_clinic.laboratory_director, 'medical_director' => cur_clinic.medical_director, 'zip' => cur_clinic.zip}
          @clinic_results << cur_new_object
        end
      end
    end
  end

  def new
	  @title = "Sign Up"
	  @user = User.new
	  @patient = @user.build_patient
  end

  def create
	  @user = User.new(create_user_params)
    if Patient.where(:username => params[:patient][:username]).exists?
      flash[:error] = "There is already a user with that username."
      redirect_to :back
    else
  	  @patient = @user.build_patient(create_patient_params)
  	  if @user.save
  	    @user.toggle!(:patient_account)
  	    sign_in @user
  	    flash[:success] = "Welcome to IVF Reports!"
	    
  	    redirect_to @patient
  	  else
  	    @title = "Sign Up"
  	    render 'new'
  	  end
    end
  end

  def edit
	  @title = "Settings"
	  @patient = Patient.find_by_permalink(params[:id])
	  @user = @patient.user
  end
  
  def update
	  @patient = Patient.find_by_permalink(params[:id])
	  @user = @patient.user
	  
    success = false
    
    unless params[:personal_info].nil?
      if @patient.update_attributes(params[:personal_info])
        success = true
	    end
    end
	  

	  unless params[:account_info].nil?	  
	    if @user.update_attributes(params[:account_info])
        success = true
	    end
    end
	  
	  @response = @user.errors
	  
	  respond_to do |format|
	    format.html do |f| 
	        if @patient.update_attributes(params[:patient])
            flash[:success] = "Zip Code Radius Successfully Updated"
    	      redirect_to @patient
  	      else
  	        flash[:error] = "There was an error processing your request."
  	        render 'show'
    	    end
      end
	    format.js {render :layout => false }
    end
  end
  
  def destroy
	  if current_user?(User.find_by_permalink(params[:id]))
		  flash[:notice] = "You cannot destroy yourself"
	  else
		  User.find_by_permalink(params[:id]).destroy
		  flash[:success] = "User destroyed."
	  end
	  respond_to do |format|
	    format.html
	    format.js
    end
  end
  
  private
    def create_user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  
    def create_patient_params
      params.require(:patient).permit(:username)
    end
	
  	def correct_user
  	  @patient = Patient.find_by_permalink(params[:id])
  	  @user = @patient.user
  	  redirect_to(root_path) unless current_user?(@user)
  	end
	
  	def admin_user
  	  redirect_to(root_path) unless current_user.admin?
  	end
	
  	def insurance_user
  	  redirect_to(root_path) unless current_user.insurer?
  	end
end
