class Dashboard::PropertyUnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [:index, :create, :update]
  before_action :set_property_unit, only: [:show, :destroy, :update, :occupancy_data]

  def index
    @q = @property.property_units.ransack(params[:q])
    @pagy, @property_units = pagy(@q.result.order(created_at: :asc), distinct: :true)
  end

  def show
    @rooms = @property_unit.rooms
  end

  def create
    @property_unit = @property.property_units.new(property_unit_params)
    if @property_unit.save
      redirect_to dashboard_property_path(@property), notice: "Property Unit Successfully created"
    else
      redirect_to dashboard_property_path(@property), alert: @property_unit.errors.full_messages.first
    end
  end


  def update
    if @property_unit.update(property_unit_params)
      redirect_to dashboard_property_property_unit_path(@property), notice: "Property Unit Successfully updated"
    else
      redirect_to edit_dashboard_property_property_unit_path(@property), alert: @property_unit.errors.full_messages.first
    end
  end


  def destroy
    if @property_unit.destroy
      redirect_to dashboard_property_path(@property_unit.property), notice: "Property Unit Successfully removed"
    else
      redirect_to dashboard_property_path(@property_unit.property), alert: @property_unit.errors.full_messages.first
    end
  end

  def property_units
    property = Property.find(params[:id])
    property_units = property.property_units

    render json: property_units.as_json(only: [:id, :name])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Property not found' }, status: :not_found
  end

  def rooms
    property_unit = PropertyUnit.find(params[:id])
    rooms = property_unit.rooms

    render json: rooms.as_json(only: [:id, :name])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Property unit not found' }, status: :not_found
  end

  def occupancy_data
    rooms = @property_unit.rooms
    total_upper_deck = rooms.sum(:upper_deck)
    total_lower_deck = rooms.sum(:lower_deck)
    total_occupants = @property_unit.tenants.count
    total_bedspaces = total_upper_deck + total_lower_deck
    property_address = @property_unit.property.address

    render json: {
      property_unit_name: @property_unit.name,
      property_address: property_address,
      property_unit_id: @property_unit.id,
      total_occupants: total_occupants,
      total_bedspaces: total_bedspaces,
      total_upper_deck: total_upper_deck,
      total_lower_deck: total_lower_deck
    }
  end


  private

  def set_property
    @property = Property.find_by(id: params[:property_id])
  end

  def set_property_unit
    @property_unit = PropertyUnit.find_by(id: params[:id])
  end

  def property_unit_params
    params.require(:property_unit).permit(:name)
  end
end
