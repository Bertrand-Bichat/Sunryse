class NotificationsController < ApplicationController
  after_action :mark_as_read, only: [:filtered_index]

  def filtered_index
    @user_notifications = authorize policy_scope(Notification).includes(:sender, :receiver).where(receiver: current_user, visible_receiver: true).order(id: :desc).paginate(page: params[:page], per_page: 50)
    @nbr_new_notifications = policy_scope(Notification).includes(:receiver).where(receiver: current_user, readed: false).size
  end

  def ninja_mode
    authorize :notification, :ninja_mode?

    time = params[:user][:ninja_time].to_i

    if (time <= current_user.ninja_time) && (time >= 1)
      current_user.update(ninja_activated: true)
      ReduceNinjaTimeJob.perform_later(current_user, time)
      DesactivateNinjaModeJob.set(wait: time.minute).perform_later(current_user)
      if current_user.ninja_reset == false
        current_user.update(ninja_reset: true)
        ResetNinjaTimeJob.set(wait_until: Date.tomorrow.beginning_of_day).perform_later(current_user)
      end
      return redirect_back fallback_location: notifications_path, notice: "Le mode invisible est activé pour #{time} minutes."
    else
      return redirect_back fallback_location: notifications_path, alert: "Veuillez sélectionner un temps < ou = à #{current_user.ninja_time} minutes."
    end
  end

  def hide_notification
    @notification = authorize policy_scope(Notification).find(params[:id])

    if @notification.sender == current_user
      HideElementSenderJob.perform_later(@notification)
    elsif @notification.receiver == current_user
      HideElementReceiverJob.perform_later(@notification)
    end

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: notifications_path, notice: 'La notification a bien été cachée.' }
    end
  end

  private

  def mark_as_read
    notifications_not_readed = policy_scope(Notification).where(receiver: current_user, readed: false)

    notifications_not_readed.each do |notification|
      MarkAsReadJob.perform_later(notification)
    end
  end
end
