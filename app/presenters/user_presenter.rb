class UserPresenter
  def initialize(user)
    @user = user
  end

  def property
    @user.utility_staff? ?  @user.utility_staff.property&.address : @user.tenant.property&.address
  end

  def property_unit
    @user.utility_staff? ? @user.utility_staff.property_unit&.name : @user.tenant.property_unit&.name
  end

  def room
    @user.utility_staff? ? @user.utility_staff.room&.name : @user.tenant.room&.name
  end

  def deck
    @user.utility_staff? ? @user.utility_staff.deck.titleize : @user.tenant.deck.titleize
  end

  def check_in
    @user.utility_staff? ? @user.utility_staff.check_in.strftime("%B %d, %Y %I:%M %p") : @user.tenant.check_in.strftime("%B %d, %Y %I:%M %p")
  end

  def accomodation
    @user.utility_staff ? @user.utility_staff.room&.accomodation : @user.tenant.room&.accomodation
  end

  def was_transferred?
    (@user.utility_staff? ? @user.utility_staff.transfer_date : @user.tenant.transfer_date).present?
  end

  def transfer_in
    @user.utility_staff? ? @user.utility_staff.transfer_date.strftime("%B %d, %Y %I:%M %p") : @user.tenant.transfer_date.strftime("%B %d, %Y %I:%M %p")
  end
end
