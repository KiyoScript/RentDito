module ApplicationHelper
  def notification_container_class
    if user_signed_in?
      base_class = "transition transform duration-5000 hidden toast-container position-fixed top-0 end-0 px-3 pb-3 pt-4 mt-5"
    else
      base_class = "transition transform duration-5000 hidden toast-container position-fixed top-0 end-0 px-3 pb-3 pt-5 mt-5"
    end
    return base_class
  end
end
