require 'test_helper'

class UsersUpdateTest < ActionDispatch::IntegrationTest
  setup do
    @user=users(:Michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    follow_redirect!
    assert_template 'sessions/new'
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
  end
  
  test "Successful edit with friendly forwarding" do
    get edit_user_path(@user) #一度編集ページに入り失敗
    log_in_as(@user) #失敗したのでログイン
    assert_redirected_to edit_user_path(@user) #この時には編集ページにログイン
    patch user_path(@user), params: {
      user: { 
        name:"mic",
        email:"mic@gmail.com",
        password:"",
        password_confirmation:""
        }}
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    assert_template 'users/show'
    @user.reload
    assert_equal "mic@gmail.com",@user.email
  end
end
