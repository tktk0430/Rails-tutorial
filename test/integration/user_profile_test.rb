require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  setup do
    @user=users(:Michael)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template "users/show"
    assert_select 'title', "#{@user.name} | Ruby on Rails Tutorial Sample App"
    assert_select 'div.pagination'
    assert_match @user.microposts.count.to_s, response.body
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_select 'a[href=?]', user_path(@user)
      assert_match micropost.content, response.body
    end
  end
end
