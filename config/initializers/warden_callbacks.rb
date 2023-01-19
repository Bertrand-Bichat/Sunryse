#when user sing_up
Warden::Manager.after_set_user do |user,auth,opts|
  # set online to true
  if user.online == false
    ToggleUserOnlineJob.perform_later(user, true)
  end
end

# when user sign_in
Warden::Manager.after_authentication do |user,auth,opts|
  # set online to true
  if user.online == false
    ToggleUserOnlineJob.perform_later(user, true)
  end
end

# when user disconnect
Warden::Manager.before_logout do |user,auth,opts|
  # set online to false
  if user.online == true
    ToggleUserOnlineJob.perform_later(user, false)
  end

  # reset current position (lon & lat)
  if user.current_latitude || user.current_longitude
    ResetUserCurrentPositionJob.perform_later(user)
  end
end
