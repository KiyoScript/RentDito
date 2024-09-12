class Dashboard::PropertyUnitsController < ApplicationController
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
end
