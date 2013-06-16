# -*- encoding : utf-8 -*-
require 'test_helper'

class Api::LogsControllerTest < ActionController::TestCase
  test "should get show_since" do
    get :show_since
    assert_response :success
  end

end
