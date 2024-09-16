class Dashboard::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!
  before_action :set_room, only: %i[show destroy decks]

  def index
    @q = Room.ransack(params[:q])
    @pagy, @rooms = pagy(@q.result.includes(:property, :property_unit).order(name: :asc).order(created_at: :asc), distinct: :true)
    @rooms = @rooms.with_bedspace_availability(params.dig(:q, :bedspace_availability_eq)) if params.dig(:q, :bedspace_availability_eq).present?
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to dashboard_rooms_path, notice: "Successfully created"
    else
      redirect_to new_dashboard_room_path, alert: @room.errors.full_messages.first
    end
  end

  def show; end

  def destroy
    if @room.destroy
      redirect_to dashboard_rooms_path, notice: "Room successfully removed"
    else
      redirect_to dashboard_room_path(@room), alert: @room.errors.full_messages.first
    end
  end

  def decks
    available_decks = []
    available_decks << "upper" if @room.upper_deck > 0
    available_decks << "lower" if @room.lower_deck > 0
    render json: { decks: available_decks }
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::RoomsPolicy
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :lower_deck, :upper_deck, :property_id, :property_unit_id, :accomodation)
  end
end
