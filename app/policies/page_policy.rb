class PagePolicy < Struct.new(:user, :page)

  def home?
    true
  end

  def cgv?
    true
  end

  def profil_match?
    user_loggedin?
  end

  def admin_dashboard?
    if user_loggedin?
      user.admin?
    end
  end

  def admin_dashboard_profils?
    admin_dashboard?
  end

  def admin_dashboard_orders?
    admin_dashboard?
  end

  def admin_dashboard_messages?
    admin_dashboard?
  end

  def admin_dashboard_pages?
    admin_dashboard?
  end

  def edit?
    update?
  end

  def update?
    if user_loggedin?
      user.admin?
    end
  end

  def user_banned?
    admin_dashboard?
  end

  def profil?
    user_loggedin?
  end

  def my_favorites?
    authorization
  end

  def delete_photo_attachment?
    user_loggedin?
  end

  def search_profils?
    authorization
  end

  def my_stories?
    user_loggedin?
  end

  def all_stories?
    user_loggedin?
  end

  def check_credit_activated?
    user_loggedin?
  end

  def applications?
    false
  end

  def next_to_current_position?
    authorization
  end

  def update_user_position?
    authorization
  end

  def user_loggedin?
    (user != nil) && !user.banned?
  end

  def authorization
    if user_loggedin?
      user.authorized?
    end
  end
end
