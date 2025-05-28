class Api::DealRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deal_room, only: [:show, :update, :destroy]

  def index
    @deal_rooms = current_user.deal_rooms.includes(:lead, :conversations)
    render json: @deal_rooms, include: [:lead, :conversations]
  end

  def show
    render json: @deal_room, include: [:lead, :conversations, :documents]
  end

  def create
    @deal_room = current_user.deal_rooms.new(deal_room_params)
    if @deal_room.save
      render json: @deal_room, status: :created
    else
      render json: @deal_room.errors, status: :unprocessable_entity
    end
  end

  def update
    if @deal_room.update(deal_room_params)
      render json: @deal_room
    else
      render json: @deal_room.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @deal_room.destroy
    head :no_content
  end

  private

  def set_deal_room
    @deal_room = current_user.deal_rooms.find(params[:id])
  end

  def deal_room_params
    params.require(:deal_room).permit(:name, :stage, :lead_id)
  end
end