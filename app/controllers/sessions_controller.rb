class SessionsController < ApplicationController

  def new
    @user=User.new
  end

  def create
    user=User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      if user.activated?
        flash[:success]="Log in success"
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        login user
        redirect_back_or user
      else
        flash[:danger]="account not activated, please find email"
        redirect_to root_path
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render "new"
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end
