require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup #
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name="   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email="   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name="a"*100
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email="a" * 256+ "@example.com"
    assert_not @user.valid?, "#{@user.email}はそんなに長くない"
  end

  test "email validation should accept valid addresses" do
    valid_addresses=%w(user@example.com UsEr@foo.co.jp.jp _____@gmail.com)
    valid_addresses.each do |address|
      @user.email=address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "authenticated? do not work with nil remember digest" do
    assert_not @user.authenticated?(:remember,"aiueo")
  end
 

  test "email validation should reject invalid addresses" do
    invalid_addresses=%w(aaa@com@com abcd@aaaa example abc@ee++aa)
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address} should be rejected !"
    end
  end

  test "email address should be unique" do
    duplicate_user=@user.dup
    duplicate_user.email=@user.email.upcase
    @user.save
    assert_not duplicate_user.valid?, "there are #{@user.email} & #{duplicate_user.email}"
  end

  test "email address not blank" do
    @user.password=@user.password_confirmation=""
    assert_not @user.valid?
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
