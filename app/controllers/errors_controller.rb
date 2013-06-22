class ErrorsController < ApplicationController
  def not_found
    @admin_user = User.find(1)
    render :status => 404, :formats => [:html]
  end

  def server_error
    @admin_user = User.find(1)
    render :status => 500, :formats => [:html]
  end
end
