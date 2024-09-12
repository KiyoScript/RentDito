class UserPresenter
  def initialize(user)
    @user = user
  end

  def property
    @user.caretaker? ?  @user.caretaker.property.address : @user.tenant.property.address
  end

  def property_unit
    @user.caretaker? ? @user.caretaker.property_unit.name : @user.tenant.property_unit.name
  end

  def room
    @user.caretaker? ? @user.caretaker.room.name : @user.tenant.room.name
  end

  def deck
    @user.caretaker? ? @user.caretaker.deck : @user.tenant.deck
  end

  def check_in
    @user.caretaker? ? @user.caretaker.check_in : @user.tenant.check_in
  end
end
