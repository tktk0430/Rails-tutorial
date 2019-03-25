require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect index when not logged in" do
    get users_url
    assert_redirected_to login_url
  end
  
  setup do
    @user=users(:Michael)
    @other_user = users(:Archer)
  end

  test "should redirect edit when not logged in" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when not logged in" do
    log_in_as(@other_user)
    patch user_path(@user), params:{user:{name:"hoge", email:"fuga"}}
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "ログインせずにuser#destroyは失敗" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "ログインしててもadminでなければuser#destroyは失敗" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_path
  end

  test "ログインしててかつadminならuser#destroyは成功" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_path
  end
end
