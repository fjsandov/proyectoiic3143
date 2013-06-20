# -*- encoding : utf-8 -*-
class Personal::ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
    @shift_new = Shift.new
  end

  def create
  end

  def update
  end
end
