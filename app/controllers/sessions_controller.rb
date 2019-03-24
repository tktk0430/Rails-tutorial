class SessionsController < ApplicationController

  def new
    @user=User.new
  end

  def create
    user=User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      flash[:success]="Log in success"
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      login user
      redirect_to user
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
