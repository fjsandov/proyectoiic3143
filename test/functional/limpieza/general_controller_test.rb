# -*- encoding : utf-8 -*-
require 'test_helper'

class Limpieza::GeneralControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
