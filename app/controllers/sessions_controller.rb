class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:login][:email].downcase)

    if @user && @user.authenticate(params[:login][:password])
      session[:user_id] = @user.id.to_s
      if @user.admin?
        redirect_to admin_dashboard_path, notice: "Logged in as Admin User: #{@user.name}"
      else
        redirect_to dashboard_path, notice: 'You have been successfully logged in!'
      end
    else
      flash.now.alert = 'Incorrect email or password, please try again.'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: 'You have been successfully logged out!'
  end
end
