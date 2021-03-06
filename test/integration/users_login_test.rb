require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:mysize1)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { mysize_id: "",
                               password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { mysize_id: @user.mysize_id,
                               password: 'password' }
    assert is_logged_in?
    assert_not_empty cookies['remember_token']
    assert_redirected_to latest_path
    follow_redirect!
    delete logout_path
    assert_not is_logged_in?
    assert_empty cookies['remember_token']
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
