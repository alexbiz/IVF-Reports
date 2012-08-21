class AdminsController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, 	:only => [:edit, :update]
  before_filter :admin_user

  def show
	  @admin = Admin.find(params[:id])
	  @clinics = Clinic.all
	  @user = @admin.user
	  @title = "#{@admin.first_name} #{@admin.last_name}"
  end

  def edit
	  @title = "Settings"
	  @admin = Admin.find(params[:id])
	  @user = @admin.user
  end

  def update
	  @admin = Admin.find(params[:id])
	  @user = @admin.user

    success = false

    unless params[:personal_info].nil?
      if @admin.update_attributes(params[:personal_info])
        success = true
        @response = @admin.errors
	    end
    end


	  unless params[:account_info].nil?	  
	    if @user.update_attributes(params[:account_info])
        success = true
        @response = @user.errors        
	    end
    end



	  respond_to do |format|
	    format.js {render :layout => false }
    end
  end

  private
  	def correct_user
  	  @admin = Admin.find(params[:id])
  	  @user = @admin.user
  	  redirect_to(root_path) unless current_user?(@user)
  	end

  	def admin_user
  	  redirect_to(root_path) unless current_user.admin_account?
    end
  
end
