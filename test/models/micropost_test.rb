require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  setup do
    @user=users(:Michael)
    @micropost=@user.microposts.build(content: "Lorem ipsum")
  end
  
  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    assert_not @micropost.user_id.nil?
  end

  test "content should not be blank" do
    @micropost.content=""
    assert_not @micropost.valid?
  end

  test "content should not be too long" do
    @micropost.content="a" * 141
    assert_not @micropost.valid?
  end

  test "order should be descent" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
