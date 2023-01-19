require 'sidekiq/web'

Rails.application.routes.draw do

  # Devise
  # devise_for :users
  devise_for :users, controllers: { registrations: 'registrations' }
  #             path_names: { sign_in: '', sign_up: 'inscription', sign_out: 'deconnecter'}
  #             path: '',

  # if Rails.env == "development"
  #   devise_for :users, controllers: { registrations: 'registrations' }
  # elsif Rails.env == "production"
  #   devise_for :users, controllers: { registrations: 'users/registrations' }
  # end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # devise_scope :user do
  #   delete 'users/:id/delete-account', to: 'registrations#admin_destroy', as: :admin_destroy
  # end

  # Pages
  # get '/a-propos', to: 'pages#about_us', as: :about_us
  # get '/mentions-legales', to: 'pages#legal_notice', as: :legal_notice
  get '/accueil', to: 'pages#home', as: :home
  # root to: 'pages#home'
  get '/conditions-generales-de-vente', to: 'pages#cgv', as: :cgv
  get '/mes-profils-compatibles', to: 'pages#profil_match', as: :profil_match
  get '/admin-dashboard', to: 'pages#admin_dashboard', as: :admin_dashboard
  get '/admin-dashboard/profils', to: 'pages#admin_dashboard_profils', as: :admin_dashboard_profils
  get '/admin-dashboard/orders', to: 'pages#admin_dashboard_orders', as: :admin_dashboard_orders
  get '/admin-dashboard/messages', to: 'pages#admin_dashboard_messages', as: :admin_dashboard_messages
  get '/admin-dashboard/pages', to: 'pages#admin_dashboard_pages', as: :admin_dashboard_pages
  get '/profil/:slug', to: 'pages#profil', as: :profil
  get '/mes-favoris', to: 'pages#my_favorites', as: :my_favorites
  get '/profils-recherches', to: 'pages#search_profils', as: :search_profils
  get '/stories/:slug', to: 'pages#my_stories', as: :my_stories
  get '/stories', to: 'pages#all_stories', as: :all_stories
  delete 'users/:id/delete_photo_attachment', to: 'pages#delete_photo_attachment', as: :delete_photo_attachment_user
  get '/check-credit-activated', to: 'pages#check_credit_activated', as: :check_credit_activated
  # get '/mini-jeux', to: 'pages#applications', as: :applications
  patch '/user-banned/:id', to: 'pages#user_banned', as: :user_banned
  get '/profils-a-cote-de-ma-position-actuelle', to: 'pages#next_to_current_position', as: :next_to_current_position
  get '/update_position', to: 'pages#update_user_position',  as: :update_position

  # pages model
  get '/pages/:id/edit', to: 'pages#edit', as: :edit_page
  patch '/pages/:id', to: 'pages#update', as: :page
  put '/pages/:id', to: 'pages#update'

  # contact
  post '/contacts', to: 'messages#create', as: :messages
  get '/contact', to: 'messages#new', as: :new_message

  # favorites
  post '/favoris', to: 'favorites#create'
  delete '/favoris/:id', to: 'favorites#destroy', as: :favorite

  # publications
  get '/mur-des-publications', to: 'publications#filtered_index', as: :publications
  post '/mur-des-publications', to: 'publications#create'
  get '/publications/:id/edit', to: 'publications#edit', as: :edit_publication
  patch '/publications/:id', to: 'publications#update', as: :publication
  put '/publications/:id', to: 'publications#update'
  delete '/publications/:id', to: 'publications#destroy'

  # contact requests
  get '/mes-demandes-de-contact', to: 'contact_requests#filtered_index', as: :contact_requests
  post '/mes-demandes-de-contact', to: 'contact_requests#create'
  delete '/mes-demandes-de-contact/:id', to: 'contact_requests#destroy', as: :contact_request # destroy useless
  patch '/demande-de-contact-acceptee/:id', to: 'contact_requests#mark_as_accepted', as: :mark_as_accepted
  patch '/demande-de-contact-cachee/:id', to: 'contact_requests#hide_contact_request', as: :hide_contact_request

  # notifications
  get '/notifications', to: 'notifications#filtered_index', as: :notifications
  patch '/mode-invisible', to: 'notifications#ninja_mode', as: :ninja_mode
  patch '/notification-cachee/:id', to: 'notifications#hide_notification', as: :hide_notification

  # blockages
  get '/mes-comptes-bloques', to: 'blockages#filtered_index', as: :blockages
  post '/mes-comptes-bloques', to: 'blockages#create'
  delete '/mes-comptes-bloques/:id', to: 'blockages#destroy', as: :blockage

  # orders
  get '/mes-commandes', to: 'orders#filtered_index', as: :orders
  post '/mes-commandes', to: 'orders#create'
  delete '/mes-commandes/:id', to: 'orders#destroy', as: :order
  get '/ma-commande-en-cours', to: 'orders#current_order', as: :current_order
  get '/tarifs', to: 'orders#choose_prices', as: :choose_prices
  get '/mes-commandes/:id/payer', to: 'orders#pay_order', as: :pay_order
  get '/panier', to: 'orders#basket', as: :basket
  patch '/annuler-abonnement', to: 'orders#unsubcribed', as: :unsubcribed

  # payment page
  get '/mes-commandes/panier/:order_id/paiement', to: 'payments#new', as: :new_order_payment

  # chatrooms
  get '/chatrooms', to: 'chatrooms#index', as: :chatrooms
  get '/chatrooms/:id', to: 'chatrooms#show', as: :chatroom
  patch '/chatrooms/:id/depense-credit', to: 'chatrooms#use_credit', as: :use_credit

  # posts
  post '/chatrooms/:chatroom_id/posts', to: 'posts#create', as: :chatroom_posts

  # payment_intents
  get '/commandes/:order_id/paiements', to: 'payment_intents#filtered_index', as: :payment_intents
  patch '/commandes/:order_id/paiements/:id', to: 'payment_intents#refund', as: :refund
  patch '/paiements/:id/mise-a-jour-statut', to: 'payment_intents#check_refund_status', as: :check_refund_status

  # games
  # get '/jeux', to: 'games#index', as: :games
  # get '/jeux/:id', to: 'games#show', as: :game

  # error pages
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unacceptable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Stirpe webhook
  mount StripeEvent::Engine, at: '/stripe-webhooks'

  # Sidekiq Web UI, only for admins.
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
