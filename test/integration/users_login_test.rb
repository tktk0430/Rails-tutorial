require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params:{session:{email:"aaa", password:"a"}}
    assert_template "sessions/new"
    assert flash.any? ,"no flash"
    get root_path
    assert_not flash.any? ,"still flash"
  end

  setup do
    @user=users(:Michael)
  end

  test "login with valid information" do
    get login_path
    assert_template "sessions/new"
    assert_no_difference 'User.count' do
      post login_path, params:{session:{email:"michael@gmail.com", password:"password"}}
    end
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert flash.any? ,"no flash"
    assert_select "a[href=?]", login_path,count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert session[:user_id]
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), count:0
    delete logout_path #別のウィンドウでのログアウトを想定
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user,remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user,remember_me: '1')
    delete logout_path
    log_in_as(@user,remember_me: '0')
    assert_empty cookies['remember_token']
  end

  test "login with no session" do
    log_in_as(@user,remember_me: '1')
    assert is_logged_in?, "Session id is #{session['user_id']}"
    session[:user_id]=nil
    assert_not session["user_id"], "Session id is #{session['user_id']}"
    get root_url #再度ページにアクセスすることでcurrent_userメソッドが働いてsessionが復活するはず
    assert session['user_id'], "Session id is #{session['user_id']}"
  end
end
