require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user=users(:Michael)
  end

  test "account_activation" do
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation(@user)
    assert_equal "Account activation", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["no_reply@example.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded #activation_tokenはユーザーモデルのゲッターメソッド
    assert_match CGI.escape(@user.email), mail.body.encoded #@を%40に直すメソッド
  end

  test "password reset" do
    @user.reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal "Password Reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["no_reply@example.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.reset_token, mail.body.encoded #activation_tokenはユーザーモデルのゲッターメソッド
    assert_match CGI.escape(@user.email), mail.body.encoded #@を%40に直すメソッド
  end
end
