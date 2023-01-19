class RegistrationsController < Devise::RegistrationsController

  # def admin_destroy
  #   user = User.find(params[:id])

  #   if current_user.admin?
  #     user.destroy
  #     redirect_to admin_dashboard_path, notice: "Le compte de #{user.pseudo} a bien été supprimé définitivement."
  #   else
  #     redirect_to home_path, alert: "Vous n'êtes pas autorisé à effectuer cette action."
  #   end
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)

    # Require current password if user is trying to change password.
    # return super if params["password"]&.present?

    # Allows user to update registration information without password.
    # resource.update_without_password(params.except("current_password"))
  end

  def after_update_path_for(resource)
    profil_path(resource.slug)
  end
end
