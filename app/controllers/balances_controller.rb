class BalancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!, only: :index

  def index;end

  private
  def set_policy!
    authorize User, policy_class: BalancesPolicy
  end
end
