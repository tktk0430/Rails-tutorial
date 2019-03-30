class ApplicationController < ActionController::Base
  include SessionsHelper
  
  def hello
    render html: "hello world"
  end

  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger]="Please log in"
      redirect_to login_path
    end
  end

  def correct_user
    user=User.find(params[:id])
    unless current_user?(user)
      flash[:danger]="You can not access this page !"
      redirect_to root_path
    end
  end
end
