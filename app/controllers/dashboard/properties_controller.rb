class Dashboard::PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [:edit, :update, :show, :destroy]
  before_action :set_policy! , except: [:render_property_units]
  def index
    @q = Property.ransack(search_params)
    @pagy, @properties = pagy(@q.result.order(created_at: :asc), distinct: :true)
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

  def edit;end

  def update
    if @property.update(property_params)
      redirect_to dashboard_property_path(@property), notice: "Successfuly update"
    else
      redirect_to edit_dashboard_property_path(@property), alert: @property.errors.full_messages.first
    end
  end

  def show
    @q = @property.property_units.ransack(params[:q])
    @pagy, @property_units = pagy(@q.result.order(created_at: :asc), distinct: :true)
  end

  def destroy
    if @property.destroy
      redirect_to dashboard_properties_path, notice: "Property Successfully removed"
    else
      redirect_to dashboard_properties_path, alert: @property.errors.full_messages.first
    end
  end

  def render_property_units
    @property_units = PropertyUnit.where(property_id: params[:id])
    Rails.logger.debug("Property Units: #{@property_units.to_json}")
    render json: @property_units.as_json(only: [:id, :name])
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::PropertiesPolicy
  end

  def set_property
    @property = Property.find_by(id: params[:id])
  end

  def property_params
    params.require(:property).permit( :city,:barangay)
  end

  def search_params
    params.fetch(:q, {}).permit(:city_or_barangay_cont)
  end
end
