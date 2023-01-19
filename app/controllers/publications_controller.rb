class PublicationsController < ApplicationController
  before_action :find_publication, only: [:edit, :update, :destroy]

  def filtered_index
    @publication = Publication.new
    @publications = authorize policy_scope(Publication).includes(:user).order(id: :desc).paginate(page: params[:page], per_page: 50)

    # if current_user.admin?
    #   @publications = authorize policy_scope(Publication).includes(:user).order(id: :desc).paginate(page: params[:page], per_page: 50)
    # else
    #   @publications = authorize policy_scope(Publication).includes(:user).where(user: full_matches).order(id: :desc).paginate(page: params[:page], per_page: 50)
    # end
  end

  def create
    @publication = Publication.new(publication_params)
    @publication.user = current_user
    authorize @publication

    if @publication.save
      redirect_to publications_path, notice: 'Votre nouvelle publication a bien été prise en compte.'
    else
      # flash[:alert] = "Il manque des informations"
      render :new
    end
  end

  def edit; end

  def update
    if @publication.update(publication_params)
      redirect_to publications_path, notice: "Vos modifications ont bien été prises en compte."
    else
      render :edit
    end
  end

  def destroy
    @publication.destroy

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: publications_path, notice: 'Votre publication a bien été supprimée.' }
    end
  end

  private

  def find_publication
    @publication = authorize policy_scope(Publication).find(params[:id])
  end

  def publication_params
    params.require(:publication).permit(:content)
  end
end
