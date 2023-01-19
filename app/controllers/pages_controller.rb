class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :cgv]
  skip_before_action :test_user_authorization, only: [
    :home,
    :cgv,
    :profil_match,
    :profil,
    :delete_photo_attachment,
    :my_stories,
    :all_stories
  ]

  def home
    authorize :page, :home?

    if user_signed_in? && current_user.admin?
      return redirect_to admin_dashboard_path
    elsif user_signed_in? && current_user.authorized?
      return redirect_to publications_path
    elsif user_signed_in?
      return redirect_to profil_path(current_user.slug)
    else
      return redirect_to root_path
    end
  end

  def cgv
    authorize :page, :cgv?
    # add_breadcrumb 'Condition générales de vente', cgv_path
  end

  def profil_match
    authorize :page, :profil_match?

    @user_matches = matches_with_avatar
    @number = @user_matches.size

    # @markers = @user_matches.map do |user|
    # {
    #   lat: user.latitude,
    #   lng: user.longitude,
    #   infoWindow: render_to_string(partial: 'shared/info_window', locals: { user: user }),
    #   image_url: helpers.asset_url('pointer.png')
    # }
    # end
  end

  def admin_dashboard
    authorize :page, :admin_dashboard?
  end

  def admin_dashboard_profils
    authorize :page, :admin_dashboard_profils?

    @customers = User.where(admin: false).order(pseudo: :asc)
    @customers_number = @customers.size
  end

  def admin_dashboard_messages
    authorize :page, :admin_dashboard_messages?

    @messages = policy_scope(Message).order(id: :desc)
    @messages_number = @messages.size
  end

  def admin_dashboard_orders
    authorize :page, :admin_dashboard_orders?

    @orders_one_shot = policy_scope(Order).includes(:user).where(order_type: helpers.order_type_one_shot, state: helpers.order_state_payed).order(id: :desc)
    @orders_camera = policy_scope(Order).includes(:user).where(order_type: helpers.order_type_camera, state: helpers.order_state_payed).order(id: :desc)
    @orders_subscription = policy_scope(Order).includes(:user).where(order_type: helpers.order_type_subscription, state: helpers.order_state_payed).order(id: :desc)
    @orders_waiting = policy_scope(Order).includes(:user).where(state: helpers.order_state_wait).order(id: :desc)
  end

  def admin_dashboard_pages
    authorize :page, :admin_dashboard_pages?

    @pages = Page.all.order(id: :asc)
    @pages_number = @pages.size
  end

  def edit
    @page = authorize Page.find(params[:id])
  end

  def update
    @page = authorize Page.find(params[:id])

    if @page.update(page_params)
      return redirect_to admin_dashboard_pages_path, notice: "Vos modifications ont bien été prises en compte."
    else
      render :edit
    end
  end

  def user_banned
    authorize :page, :user_banned?

    @user = User.find(params[:id])
    @user.update(banned: !@user.banned)

    respond_to do |format|
      format.js
    end
  end

  def profil
    authorize :page, :profil?

    @user = User.find(params[:slug])
    @target_blockage = policy_scope(Blockage).find_by(initiator: current_user, target: @user)
    @initiator_blockage = policy_scope(Blockage).find_by(initiator: @user, target: current_user)

    # can't see profile of a banned user
    if @user.banned?
      return redirect_to home_path, alert: "Cet utilisateur a été banni."
    # admin profil can't be seen
    elsif @user.admin?
      return redirect_to home_path, alert: "Vous n'êtes pas autorisé à effectuer cette action."
    # @user profil can't be seen if there is a blockage
    elsif @target_blockage.present? || @initiator_blockage.present?
      return redirect_to blockages_path, alert: "Vous ne pouvez pas intéragir avec #{@user.pseudo}."
    end

    # photos N+1 queries
    @user_photos = @user&.photos&.includes(:blob)

    # pour le bouton 'ajouter à mes favoris'
    @favorite = Favorite.new
    @favorite_user = policy_scope(Favorite).find_by(user_id: current_user.id, profile_id: @user.id)

    # pour le bouton 'envoyer une demande de contact'
    @contact_request = ContactRequest.new
    @contact_request_sent = policy_scope(ContactRequest).find_by(sender: current_user, receiver: @user)
    @contact_request_received = policy_scope(ContactRequest).find_by(sender: @user, receiver: current_user)

    # pour le bouton 'bloquer cet utilisateur'
    @blockage = Blockage.new

    # markdown to render custom CKEditor textarea
    @user_beliefs = markdown_to_html(@user.beliefs) if @user.beliefs
    @user_projects = markdown_to_html(@user.projects) if @user.projects
    @user_movies = markdown_to_html(@user.movies) if @user.movies
    @user_books = markdown_to_html(@user.books) if @user.books
    @user_introduction = markdown_to_html(@user.introduction) if @user.introduction
    @user_description = markdown_to_html(@user.description) if @user.description
    @user_hobbies = markdown_to_html(@user.hobbies) if @user.hobbies
    @user_job = markdown_to_html(@user.job) if @user.job
    @user_qualities = markdown_to_html(@user.qualities) if @user.qualities
    @user_defaults = markdown_to_html(@user.defaults) if @user.defaults
    @user_i_want = markdown_to_html(@user.i_want) if @user.i_want
    @user_i_dont_want = markdown_to_html(@user.i_dont_want) if @user.i_dont_want

    # notifications
    unless (current_user == @user) || current_user.admin? || (current_user.ninja_activated == true)
      CreateNotificationJob.perform_later(current_user, @user, helpers.notifications_profil)
      if @user.notification_profil_seen?
        NotificationMailer.with(sender: current_user, receiver: @user).profil_seen.deliver_later
      end
    end
  end

  def my_favorites
    authorize :page, :my_favorites?

    @profiles_favorites = policy_scope(Favorite).where(user_id: current_user.id).order(id: :asc).map{ |favorite| User.find(favorite.profile_id) }
    @blockages = find_blockages

    @profiles_favorites.delete_if { |user| @blockages.include?(user) || user.banned? }
    @number = @profiles_favorites.size
  end

  def delete_photo_attachment
    authorize :page, :delete_photo_attachment?

    @photo = ActiveStorage::Blob.find_signed(params[:id])
    @user = User.find(@photo.attachments.first.record_id)
    @photo.attachments.first.purge_later

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: profil_path(@user.slug), notice: 'Votre fichier a bien été supprimé.' }
    end
  end

  def search_profils
    authorize :page, :search_profils?

    if params[:query].present?
      @users = (User.includes(:avatar_attachment).search_full_text_1(params[:query]) + User.includes(:avatar_attachment).search_full_text_2(params[:query]) + User.includes(:avatar_attachment).search_full_text_3(params[:query]) + User.includes(:avatar_attachment).search_full_text_4(params[:query])).uniq
      @blockages = find_blockages

      @users.delete_if { |user| @blockages.include?(user) || user.admin? || (user == current_user) || user.banned? }
      @number = @users.size
    else
      redirect_back(fallback_location: profil_path(current_user.slug))
    end
  end

  def my_stories
    authorize :page, :my_stories?

    @user = User.find(params[:slug])
    @target_blockage = policy_scope(Blockage).find_by(initiator: current_user, target: @user)
    @initiator_blockage = policy_scope(Blockage).find_by(initiator: @user, target: current_user)

    # can't see profile of a banned user
    if @user.banned?
      return redirect_to home_path, alert: "Cet utilisateur a été banni."
    # admin profil can't be seen
    elsif @user.admin?
      return redirect_to home_path, alert: "Vous n'êtes pas autorisé à effectuer cette action."
    # @user profil can't be seen if there is a blockage
    elsif @target_blockage.present? || @initiator_blockage.present?
      return redirect_to blockages_path, alert: "Vous ne pouvez pas intéragir avec #{@user.pseudo}."
    end

    @user_stories = @user&.stories&.includes(:blob).order(created_at: :desc).paginate(page: params[:page], per_page: 25)
  end

  def all_stories
    authorize :page, :all_stories?

    @users = User.includes(stories_attachments: :blob).where(admin: false).uniq
    @blockages = find_blockages

    @users.delete_if { |user| @blockages.include?(user) || user.admin? || user.banned? }
    @users_stories = @users&.map { |user| user.stories }.flatten.sort_by { |story| story.created_at }.reverse.paginate(page: params[:page], per_page: 25)
  end

  def check_credit_activated
    authorize :page, :check_credit_activated?

    @user = current_user

    respond_to do |format|
      format.html
      format.json { render json: @user.credit_activated }
    end
  end

  def applications
    authorize :page, :applications?
  end

  def next_to_current_position
    authorize :page, :next_to_current_position?

    @user_matches = matches_next_to_current_position

    @user_marker =
      {
        lat: current_user.current_latitude,
        lng: current_user.current_longitude,
        image_url: helpers.asset_url('mark.png')
      }

    @markers_position = @user_matches.map do |user|
      {
        lat: user.current_latitude,
        lng: user.current_longitude,
        image_url: helpers.asset_url('pointer.png'),
        infoWindow: render_to_string(partial: 'shared/info_window', locals: { user: user })
      }
    end

    # @markers_house = @user_matches.map do |user|
    #   {
    #     lat: user.latitude,
    #     lng: user.longitude,
    #     image_url: helpers.asset_url('house.png'),
    #     infoWindow: render_to_string(partial: 'shared/info_window', locals: { user: user })
    #   }
    # end
  end

  def update_user_position
    authorize :page, :update_user_position?

    @user = current_user
    @user.current_latitude = params[:latitude]
    @user.current_longitude = params[:longitude]
    @user.save

    # @user_marker =
    #   {
    #     lat: current_user.current_latitude,
    #     lng: current_user.current_longitude,
    #     image_url: helpers.asset_url('mark.png')
    #   }

    respond_to do |format|
      format.html
      format.js { head :no_content }
    end
  end

  private

  def page_params
    params.require(:page).permit(:title, :quote, :content, :main_logo, :navbar_logo, :background_photo, :favicon)
  end

  def matches_next_to_current_position
    blockages = find_blockages
    find_matches_next_to_current_position.uniq.delete_if { |user| blockages.include?(user) }
  end

  # 5 km around current_user position
  def find_matches_next_to_current_position
    User.where(
      admin: false,
      banned: false,
      gender: current_user.gender_criteria,
      goal: current_user.goal,
      shape: current_user.shape_criteria
    ).where(
      'birthday <= ?', Date.today - current_user.min_age.years
    ).where(
      'birthday >= ?', Date.today - current_user.max_age.years
    ).where.not(
      id: current_user.id,
      current_latitude: nil,
      current_longitude: nil
    ).select do |user|
      Geocoder::Calculations.distance_between([current_user.current_latitude, current_user.current_longitude], [user.current_latitude, user.current_longitude]) <= 5 # 5 km
    end
  end
end
