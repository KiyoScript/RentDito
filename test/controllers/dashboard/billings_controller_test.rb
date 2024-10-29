require "test_helper"

class Dashboard::BillingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dashboard_billings_index_url
    assert_response :success
  end
end
