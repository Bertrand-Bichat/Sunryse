class BlockagesController < ApplicationController

  def filtered_index
    @initiator_blockages = authorize policy_scope(Blockage).includes(:initiator, target: :avatar_attachment).where(initiator: current_user).order(id: :desc).paginate(page: params[:page], per_page: 50)
  end

  def create
    target_id = blockage_params["target_id"].to_i
    @target = User.find(target_id)

    @blockage = Blockage.new
    @blockage.initiator = current_user
    @blockage.target = @target
    authorize @blockage

    if @blockage.save
      redirect_to blockages_path, notice: "#{@target.pseudo} ne pourra plus intéragir avec vous, ni voir votre profil."
    else
      redirect_back fallback_location: blockages_path, alert: "Erreur de saisie."
    end
  end

  def destroy
    @blockage = authorize policy_scope(Blockage).find(params[:id])
    @target = @blockage.target
    @blockage.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to blockages_path, notice: "Vous pouvez de nouveau intéragir avec #{@target.pseudo}." }
    end
  end

  private

  def blockage_params
    params.require(:blockage).permit(:target_id)
  end
end
