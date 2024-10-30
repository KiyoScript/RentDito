require "test_helper"

class AccountSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get account_settings_show_url
    assert_response :success
  end
end
