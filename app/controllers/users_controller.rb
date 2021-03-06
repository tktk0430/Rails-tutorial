class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :followers, :following]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users=User.all
    @users=User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user=User.new(user_params) 
    if @user.save #有効かされるまでログインはさせないので下三行はコメントアウト
      #login @user
      #flash[:success]="Welcome to sample app"
      #redirect_to @user
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    @user.assign_attributes(user_params)
    if @user.save
      #Success
      flash[:success]="Succeed to update your prifile"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user=User.find(params[:id])
    user.destroy
    redirect_to users_path
  end

  def following
    @page_title="Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @page_title="Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private 
    def user_params
      params.require(:user).permit(
        :name,:email,:password,:password_confirmation
      )
    end

    def admin_user
      unless current_user.admin?
        flash[:danger]="You can not access this page !"
        redirect_to root_path
      end
    end
end
