class PasswordResetsController < ApplicationController
  before_action :get_user,only: [:edit,:update]
  before_action :valid_user,only: [:edit,:update]
  before_action :check_expiration, only: [:edit,:update]
  def index
    redirect_to new_password_reset_path
  end
  
  def new
  end

  def create
    @user=User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "please find your email to reset password"
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      login @user
      flash[:success] ="Password has been reset."
      @user.update_attribute(:reset_digest,nil)
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user #リファクタリング的に使う、見辛い・・・
    @user=User.find_by(email: params[:email])
  end

  def valid_user #@userはget_userからもらう。なのでこれはget_userの下に書く。
    unless (@user&.activated? && @user.authenticated?(:reset,params[:id])) #activated : boolean属性、authenticated? : インスタンスメソッド
      flash[:danger] = "This link is no longer valid."
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_resets_path
    end
  end
end
