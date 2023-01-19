class ApplicationController < ActionController::Base
  require 'stripe'
  require 'will_paginate/array'

  # CSRF protection
  protect_from_forgery with: :exception

  # stock la page actuelle avant d'authentifier l'utilisateur afin de pouvoir revenir dessus apres le login
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  before_action :banned?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :new_user, unless: :devise_controller?
  before_action :test_user_authorization, unless: :devise_controller?
  before_action :find_home_page
  # before_action :set_user_current_position

  # breadcrumb
  # add_breadcrumb "Accueil", :home_path

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: [:index, :my_journeys_index], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Raise an alert if not authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def find_home_page
    @page = Page.find_by(tag: 'accueil')
    @page_content = markdown_to_html(@page.content) if @page.content
  end

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end

  # def set_user_current_position
  #   position = Geocoder.search(request.location.ip).first.coordinates
  #   SetUserCurrentPositionJob.perform_later(current_user, position) if position
  # end

  def banned?
    if current_user.present? && current_user.banned?
      sign_out current_user
      redirect_to root_path, alert: "Ce compte a été suspendu pour violation des conditions générales d'utilisation."
    end
  end

  def test_user_authorization
    unless (current_user && (current_user.admin? || current_user.authorized? || current_user.gender == helpers.female))
      redirect_to choose_prices_path, alert: 'Vous devez souscrire à une formule payante pour intéragir avec les autres utilisateurs.'
    end
  end

  def new_user
    @user = User.new
  end

  def find_blockages
    initiated = Blockage.where(initiator: current_user).map { |blockage| blockage.target }
    targeted = Blockage.where(target: current_user).map { |blockage| blockage.initiator }
    (initiated + targeted).uniq
  end

  def full_matches
    matches + [current_user, User.find_by(admin: true)]
  end

  def matches
    blockages = find_blockages
    (find_matches(true) + find_matches(false)).uniq.delete_if { |user| blockages.include?(user) }
  end

  def matches_with_avatar
    blockages = find_blockages
    (find_matches_with_avatar(true) + find_matches_with_avatar(false)).uniq.delete_if { |user| blockages.include?(user) }
  end

  def find_matches(boolean)
    User.where(
      online: boolean,
      admin: false,
      banned: false,
      gender: current_user.gender_criteria,
      goal: current_user.goal,
      shape: current_user.shape_criteria
    ).where(
      'birthday <= ?', Date.today - current_user.min_age.years
    ).where(
      'birthday >= ?', Date.today - current_user.max_age.years
    ).near(
      [current_user.latitude, current_user.longitude], current_user.perimeter_criteria, units: :km
    ).where.not(
      id: current_user.id
    ).order(id: :asc)
  end

  def find_matches_with_avatar(boolean)
    User.includes(:avatar_attachment).where(
      online: boolean,
      admin: false,
      banned: false,
      gender: current_user.gender_criteria,
      goal: current_user.goal,
      shape: current_user.shape_criteria
    ).where(
      'birthday <= ?', Date.today - current_user.min_age.years
    ).where(
      'birthday >= ?', Date.today - current_user.max_age.years
    ).near(
      [current_user.latitude, current_user.longitude], current_user.perimeter_criteria, units: :km
    ).where.not(
      id: current_user.id
    ).order(id: :asc)
  end

  def markdown_to_html(markdown_text)
    # permet de transformer le text en markdown en html
    renderer = Redcarpet::Render::HTML
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(markdown_text).html_safe
    # html_safe est une verification rails pour afficher un string contenant du markdown en html
  end

  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action."
    redirect_to(home_path)
  end

  # verifie que la page peut etre stocker pour ne pas tomber dans une boucle de redirection infinie
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  # stock la page pour que l'utilisateur soit rediriger apres le login
  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def default_url_options
    { host: ENV['DOMAIN'] || 'localhost:3000' } # rajouter le nom de domaine en prod
  end

  # equivalent a user_params (qu'est-ce qu'on autorise a etre modifie)
  def configure_permitted_parameters
    # lors de la creation d'un nouveau compte
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(
        :email,
        :password,
        :password_confirmation,
        :pseudo,
        :address,
        :gender,
        :birthday,
        :shape,
        :hair,
        :eye,
        :smoke,
        :want_child,
        :lives_alone,
        :beliefs,
        :projects,
        :movies,
        :books,
        :gender_criteria,
        :goal,
        :min_age,
        :max_age,
        :perimeter_criteria,
        :i_want,
        :i_dont_want,
        shape_criteria: []
      )
    end

    # lors de la modification d'un compte deja existant
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(
        :email,
        :password,
        :password_confirmation,
        :current_password,
        :pseudo,
        :address,
        :gender,
        :birthday,
        :shape,
        :hair,
        :eye,
        :smoke,
        :want_child,
        :lives_alone,
        :beliefs,
        :projects,
        :movies,
        :books,
        :gender_criteria,
        :goal,
        :min_age,
        :max_age,
        :perimeter_criteria,
        :i_want,
        :i_dont_want,
        :introduction,
        :description,
        :hobbies,
        :job,
        :qualities,
        :defaults,
        :avatar,
        :bg_color,
        :avatar_border_color,
        :ninja_time,
        :ninja_activated,
        :ninja_reset,
        :notification_profil_seen,
        :notification_favorite_added,
        :notification_contact_request_readed,
        :notification_contact_request_accepted,
        :notification_contact_request_received,
        :notification_post_received,
        shape_criteria: [],
        photos: [],
        stories: []
      )
    end
  end
end
