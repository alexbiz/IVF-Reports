class SessionsController < ApplicationController
  def new
	  @title = "Sign In"
  end
  
  def create
	  user = User.authenticate(	params[:session][:email],
								params[:session][:password])
	if user.nil?
		flash.now[:error] = "Invalid email/password combination."
		@title = "Sign In"
		render 'new'
	else
		sign_in user
		if user.patient_account?
		  redirect_back_or user.patient
	  elsif user.clinic_account?
	    redirect_back_or user.clinic
    elsif user.professional_account?
      redirect_back_or user.professional
    elsif user.admin_account?
      redirect_back_or user.admin
    end
	end
  end
  
  def destroy
	  sign_out
	  redirect_to root_path
  end

end
