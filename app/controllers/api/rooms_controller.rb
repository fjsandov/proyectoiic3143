# -*- encoding : utf-8 -*-
class Api::RoomsController < ApplicationController

  # GET /api/rooms/1.json
  def show
    @room = Room.find(params[:id])

    respond_to do |format|
      format.json { render json: @room }
    end
  end

  # GET /api/rooms/sector/1.json
  def rooms_by_sector
    @room = Room.where(:sector_id => params[:id])

    respond_to do |format|
      format.json { render json: @room }
    end
  end

  # POST /api/rooms.json
  def create
    @room = Room.new(params[:room])

    respond_to do |format|
      if @room.save
        format.json { render json: @room, status: :created, location: @room }
      else
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api/rooms/1.json
  def update
    @room = Room.find(params[:id])

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.json { head :no_content }
      else
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/rooms/1.json
  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
end
