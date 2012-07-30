class ProfessionalsController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, 	:only => [:edit, :update]
  before_filter :admin_user, 	:only => :destroy

  def show
	  @professional = Professional.find_by_permalink(params[:id])
	  @user = @professional.user
  end

  def new
	  @title = "Sign Up"
	  @user = User.new
	  @professional = @user.build_professional
  end

  def create
	  @user = User.new(params[:user])
	  @professional = @user.build_professional(params[:professional])
	  if @user.save
	    @user.toggle!(:professional_account)
	    sign_in @user
	    flash[:success] = "Welcome to IVF Reports!"


      email_body = "<img src='#{root_url}#{ActionController::Base.helpers.asset_path('logo.png')}'><br/>"
	    email_body += "<h1>Welcome to IVF Reports</h1>"
	    email_body += "<p>IVF Reports is the premier website for finding accurate information about U.S. Fertility Clinics. As a Healthcare Professional, you can enjoy easier to analyze, in depth statistics to help you understand and make better decisions on how best to treat your patients.</p>"
	    email_body += "<p>Your Account Information:</p>"
	    email_body += "<ul><li><b>Email: </b> #{@user.email}</li></ul>"
	    email_body += "<p><a href='#{root_url}signin'>Log in</a> to view national and region ranking data, perform localized clinic searches, claim your clinic, and view in depth statistics for all U.S. Fertility Clinics.</p>"
      email_body += "<p>Thank you for being a part of our community. We look forward to helping you better serve your patients.</p>"
      email_body += "<p>Warmest regards,</p>"
      email_body += "<p>The IVF Reports Team</p>"


      Pony.mail( 
      	:to => @user.email,
      	:subject => 'Welcome to IVF Reports.',
        :headers => { 'Content-Type' => 'text/html' },      	
      	:body => email_body
      )

	    redirect_to @professional
	  else
	    @title = "Sign Up"
	    render 'new'
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
