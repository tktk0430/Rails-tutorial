class SessionsController < ApplicationController

  def new
    @user=User.new
  end

  def create
    user=User.find_by(email: params[:session][:email])
    if user&.authenticate(params[:session][:password])
      flash[:success]="Log in success "
      login user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render "new"
    end
  end

  def destroy
    logout(current_user)
    redirect_to root_path
  end
end
