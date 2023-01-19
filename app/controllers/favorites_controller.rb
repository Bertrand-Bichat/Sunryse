class FavoritesController < ApplicationController

  def create
    @favorite = Favorite.new(favorite_params)
    @favorite.user = current_user
    @receiver = User.find(@favorite.profile_id)
    authorize @favorite

    if @favorite.save
      CreateNotificationJob.perform_later(current_user, @receiver, helpers.notifications_favorite)
      if @receiver.notification_favorite_added?
        NotificationMailer.with(receiver: @receiver, sender: @favorite.user).favorite_added.deliver_later
      end
      redirect_back fallback_location: profil_path(@favorite.profile_id), notice: 'Ce profil a bien été enregistré parmi vos favoris.'
    else
      # flash[:alert] = "Il manque des informations"
      redirect_back fallback_location: profil_path(@favorite.profile_id), alert: "Erreur de saisie."
    end
  end

  def destroy
    @favorite = authorize policy_scope(Favorite).find(params[:id])
    @user_favorite = User.find(@favorite.profile_id)
    @favorite.destroy
    # flash[:notice] = "Le profil de #{@user_favorite.pseudo} a bien été retiré de vos favoris."

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: profil_path(@user_favorite.slug), notice: "Le profil de #{@user_favorite.pseudo} a bien été retiré de vos favoris." }
    end

  end

  private

  def favorite_params
    params.require(:favorite).permit(:profile_id)
  end
end
