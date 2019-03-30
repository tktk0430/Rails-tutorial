require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  setup do
    @user=users(:Michael)
    @other=users(:Archer)
  end

  test "from login to delete microposts" do
    log_in_as(@user)
    assert_redirected_to user_path(@user)
    get root_path
    assert_select 'textarea#micropost_content'
    assert_no_difference 'Micropost.count' do
      post microposts_path, params:{micropost:{content: ""}}
    end
    assert_select 'div#error_explanation'
    assert_difference 'Micropost.count',1 do
      post microposts_path, params:{micropost:{content: "test"}}
    end
    assert_redirected_to root_path
    follow_redirect!
    microposts=@user.microposts.paginate(page:1)
    #microposts.each do |micropost| #feedが絡むと@userの情報全てがhomeには乗らない
    assert_match microposts.first.content, response.body
    assert_select 'a', text: 'delete'
    #end
    first_micropost=@user.microposts.paginate(page:1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    first_micropost_others=@other.microposts.paginate(page:1).first
    assert_no_difference 'Micropost.count' do
      delete micropost_path(first_micropost_others)
    end
    assert_redirected_to root_path
    get user_path(@other)
    assert_select 'a', text: 'delete', count: 0
  end

end
