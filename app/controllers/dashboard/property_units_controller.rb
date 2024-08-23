class Dashboard::PropertyUnitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property_unit

  def index
    render json: { property_units: property_units.as_json(only: [:id, :name]) }
  end

  private

  def set_property_unit
    @property_units = PropertyUnit.where(property_id: params[:property_id])
  end
end
