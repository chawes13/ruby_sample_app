require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(name: "Conor Test", email: "conor@test.com", password: "foobarbaz",
                      password_confirmation: "foobarbaz")
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
end
