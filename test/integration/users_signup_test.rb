require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear #下のテストを行う前にメールオブジェクトをクリア
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path, params: { user: { name:  "taro",
                                         email: "user@invalid.com",
                                         password:              "foo0000",
                                         password_confirmation: "foo0000" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size #送信待ちメールオブジェクトの個数が1
    user = assigns(:user) #ここではget signup_pathによりuser#createが呼ばれているので、そこで作られているインスタンス@userが呼ばれる
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated? #dbが変わったらreloadを
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  " ",
                                         email: "user@@invalid.com",
                                         password:              "foo0000",
                                         password_confirmation: "foopppp" } }
    end
    assert_template "users/new"
  end
end
