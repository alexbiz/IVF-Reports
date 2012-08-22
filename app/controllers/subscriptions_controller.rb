class SubscriptionsController < ApplicationController
  def create
    @user = User.find_by_id(params[:user_id])
    @subscription = @user.subscriptions.build(params[:subscription])
    if @subscription.save_with_payment
      flash[:success] = "You Successfully Upgraded to a Premium Account."
      redirect_to current_user.professional
    else
      flash[:success] = "There Was an Error Upgrading to a Premium Account."
      redirect_to current_user.professional
    end
  end
end
