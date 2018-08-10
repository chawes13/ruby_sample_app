require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid form submission does not create a user" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {
        name: "",
        email: "example@email",
        password: "foo",
        password_confirmation: "bar"
      }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid form submission creates a user" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: {
        name: "Test Account",
        email: "test@email.com",
        password: "foobarbaz",
        password_confirmation: "foobarbaz"
      }}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
  end
end
