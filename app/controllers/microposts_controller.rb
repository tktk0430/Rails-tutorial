class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:destroy]
  
  def index
    redirect_to root_path
  end

  def create
    @micropost=current_user.microposts.build(microposts_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items=current_user.feed.paginate(page: params[:page])
      render 'staticpages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
  def microposts_params
    params.require(:micropost).permit(:content,:picture)
  end

  def correct_user
    @micropost=Micropost.find(params[:id])
    unless current_user==@micropost.user
      flash[:danger] = "You can not do this action"
      redirect_to root_path
    end
  end
end
