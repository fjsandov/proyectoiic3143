# -*- encoding : utf-8 -*-
require 'test_helper'

class Personal::AssistancesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
