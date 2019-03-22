require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do #該当ページにリンクが正しい個数ある？
    get root_path
    assert_template 'staticpages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
  end
end
