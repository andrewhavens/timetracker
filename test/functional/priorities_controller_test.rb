require 'test_helper'

class PrioritiesControllerTest < ActionController::TestCase
  test "should get order" do
    get :order
    assert_response :success
  end

end
