module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end
  
  def logout(user)
    session.delete(:user_id)
    @current_user=nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    #セッションが切れる対策。切れてなければ左側だけ、切れてれば右も試す。
    #@current_user = @current_user || User.find_by(nil: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
