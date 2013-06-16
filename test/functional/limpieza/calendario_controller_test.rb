# -*- encoding : utf-8 -*-
require 'test_helper'

class Limpieza::CalendarioControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create_aseo_terminal" do
    get :create_aseo_terminal
    assert_response :success
  end

end
