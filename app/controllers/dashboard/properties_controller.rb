class Dashboard::PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: %i[show destroy]
  def index
    @q = Property.ransack(search_params)
    @pagy, @properties = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end

  def new
    @property = current_user.properties.new
    @property.property_units.build
  end

  def create
    @property = current_user.properties.new(property_params)
    if @property.save
      redirect_to dashboard_properties_path, notice: "Successfully created"
    else
      redirect_to new_dashboard_property_path, alert: @property.errors.full_messages.first
    end
  end

  def show;end


  def destroy
    if @property.destroy
      redirect_to dashboard_properties_path, notice: "Property Successfully removed"
    else
      redirect_to dashboard_properties_path, alert: @property.errors.full_messages.first
    end
  end

  def property_units
    @property_units = PropertyUnit.where(property_id: params[:id])
    Rails.logger.debug("Property Units: #{@property_units.to_json}")
    render json: @property_units.as_json(only: [:id, :name])
  end

  private

  def set_property
    @property = Property.find_by_id(params[:id])
  end

  def property_params
    params.require(:property).permit(
      :city,
      :barangay,
      property_units_attributes: [:name]
    )
  end

  def search_params
    q_params = params.fetch(:q, {})
              .permit(:city_eq, :barangay_eq)
              {
                city_eq: map_enum_value(Property.cities, q_params[:city_eq]),
                barangay_eq: map_enum_value(Property.barangays, q_params[:barangay_eq])
              }.compact
  end

  def map_enum_value(enum_hash, value)
    # Return the mapped value from the enum hash, or nil if not present
    enum_hash[value.to_s] if value.present?
  end

end
