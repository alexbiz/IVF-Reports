class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, 	:only => [:edit, :update]
  before_filter :admin_user, 	:only => :destroy

  def edit
	  @title = "Settings"
  end
  
  def update
	  @user = User.find_by_id(params[:id])
	  
    success = false
    
    unless params[:personal_info].nil?
      if @user.update_attributes(params[:personal_info])
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
	        if @user.update_attributes(params[:user])
            flash[:success] = "Zip Code Radius Successfully Updated"
    	      redirect_to @user
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
	  @user = User.find_by_id(params[:id])
	  redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
	  redirect_to(root_path) unless current_user.admin?
	end
	
	def insurance_user
	  redirect_to(root_path) unless current_user.insurer?
	end
end
