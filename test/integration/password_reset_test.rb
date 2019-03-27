require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear #下のテストを行う前にメールオブジェクトをクリア
    @user=users(:Michael)
  end

  test "valid password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #無効なアドレスでreset
    post password_resets_path, params:{password_reset:{email:""}}
    assert_template "password_resets/new"
    assert_not flash.empty?
    #有効なアドレスでreset
    post password_resets_path, params:{password_reset:{email:@user.email}}
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not_equal @user.reset_digest, @user.reload.reset_digest.nil? #ここでupdate_attributesされてるのでreload, 単体テストでやること？
    user=assigns(:user) #createで作られた@userにアクセスしている？
    get edit_password_reset_path("invalid_token",email:user.email)
    assert_redirected_to root_path
    get edit_password_reset_path(user.reset_token, email:"invalidEmail")
    assert_redirected_to root_path
    get edit_password_reset_path(user.reset_token, email:user.email)
    assert_template "password_resets/edit"
    patch password_reset_path(user.reset_token), params:{#password_reset_path/tokenに送りたい
      email: user.email,
      user:{password:"hogefuga",password_confirmation:"hogefuga"}
    }
    assert_redirected_to user
    assert_not flash.empty?
    assert is_logged_in?
  end
  

end
