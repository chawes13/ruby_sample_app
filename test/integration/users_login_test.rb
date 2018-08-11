require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test_user)
  end

  test "error flash should not persist across requests" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: "conor@test.com",
        password: "foobar"
      }
    }
    assert_not flash.empty?
    assert_select 'div.alert-danger'
    get root_path
    assert flash.empty?
  end

  test "login with valid information and then logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: "test@example.com",
        password: "password"
      }
    }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, false
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', logout_path
    # Logout
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', user_path(@user), false
    assert_select 'a[href=?]', logout_path, false
  end

end
