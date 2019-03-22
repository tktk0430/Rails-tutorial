require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path, params: { user: { name:  "taro",
                                         email: "user@invalid.com",
                                         password:              "foo0000",
                                         password_confirmation: "foo0000" } }
    end
    follow_redirect!
    assert_template "users/show"
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
