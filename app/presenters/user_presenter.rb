class UserPresenter
  def initialize(user)
    @user = user
  end

  def property
    @user.utility_staff? ?  @user.utility_staff.property.address : @user.tenant.property.address
  end

  def property_unit
    @user.utility_staff? ? @user.utility_staff.property_unit.name : @user.tenant.property_unit.name
  end

  def room
    @user.utility_staff? ? @user.utility_staff.room.name : @user.tenant.room.name
  end

  def deck
    @user.utility_staff? ? @user.utility_staff.deck : @user.tenant.deck
  end

  def check_in
    @user.utility_staff? ? @user.utility_staff.check_in : @user.tenant.check_in
  end
end
