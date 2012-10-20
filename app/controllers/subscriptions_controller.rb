class SubscriptionsController < ApplicationController
  def create
    @user = User.find_by_id(params[:user_id])
    @subscription = @user.subscriptions.build(params[:subscription])
    if @subscription.save_with_payment
      if params[:subscription][:discount_code]
        flash[:success] = "You have upgraded and received one month free for code #{params[:subscription][:discount_code]}."
        redirect_to current_user.professional
      else
        flash[:success] = "You Successfully Upgraded to a Premium Account."
        redirect_to current_user.professional
      end
    else
      flash[:success] = "There Was an Error Upgrading to a Premium Account."
      redirect_to current_user.professional
    end
  end
end
