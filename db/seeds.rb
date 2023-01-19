require "open-uri"
require 'faker'

if Rails.env == "production"


  puts 'It is forbidden !'


elsif Rails.env == "development"


  puts 'cleaning database'


  Page.destroy_all
  Game.destroy_all
  PaymentIntent.destroy_all
  Event.destroy_all
  Order.destroy_all
  Post.destroy_all
  Chatroom.destroy_all
  Blockage.destroy_all
  Notification.destroy_all
  ContactRequest.destroy_all
  Publication.destroy_all
  Favorite.destroy_all
  Message.destroy_all
  User.destroy_all


  puts 'fetch images'


  # photos
  file_1 = Rails.root.join("app/assets/images/avatar.png").open


  puts 'generating users'


  # admin
  user0 = User.create({
    email: ENV['GMAIL_ADDRESS'],
    password: 'password',
    pseudo: "Administrateur SUNRYSE",
    address: "25 Rue des États Généraux, Versailles, Île-de-France, France",
    birthday: "1638-09-05",
    gender: "dieu",
    hair: "fire",
    eye: "thunder",
    smoke: false,
    want_child: false,
    lives_alone: false,
    shape: "colosse",
    gender_criteria: "mortel",
    goal: "univers",
    min_age: 100,
    max_age: 100,
    perimeter_criteria: 0,
    shape_criteria: [],
    admin: true,
    authorized: true
  })

  # test users
  user1 = User.create({
    email: "example@gmail.com",
    password: 'password',
    pseudo: "toto13",
    address: "6 Rue Albert Dubout, Marseille 8e Arrondissement, Provence-Alpes-Côte d'Azur, France",
    birthday: "1988-04-02",
    gender: "homme",
    hair: "roux",
    eye: "marron",
    smoke: false,
    want_child: false,
    lives_alone: true,
    shape: "normale",
    gender_criteria: "femme",
    goal: "relation sérieuse",
    min_age: 18,
    max_age: 100,
    perimeter_criteria: 100,
    shape_criteria: ["fine", "sportive", "kg en trop"],
    bg_color: '#0000ff',
    avatar_border_color: '#ff0000',
    camera_credits_balance: 3
  })
  user1.avatar.attach(io: file_1, filename: 'avatar.png', content_type: 'image/png')
  user1.save

  user2 = User.create({
    email: "femme@gmail.com",
    password: 'password',
    pseudo: "tata13",
    address: "167 Rue Paradis, Marseille 8e Arrondissement, Provence-Alpes-Côte d'Azur, France",
    birthday: "1988-05-02",
    gender: "femme",
    hair: "brun",
    eye: "marron",
    smoke: false,
    want_child: false,
    lives_alone: true,
    shape: "kg en trop",
    gender_criteria: "homme",
    goal: "relation sérieuse",
    min_age: 18,
    max_age: 100,
    perimeter_criteria: 100,
    shape_criteria: ["normale"],
    bg_color: '#0000ff',
    avatar_border_color: '#ff0000',
    camera_credits_balance: 3
  })

  (1..5).each do |id|
      # file = URI.open("#{Faker::Avatar.image(slug: "my-own-slug", size: "100x100", format: "jpg")}")
      user = User.new({
        email: Faker::Internet.email,
        password: "password",
        password_confirmation: "password",
        pseudo: Faker::Internet.username,
        address: "1 Rue Albert Dubout, Marseille 8e Arrondissement, Provence-Alpes-Côte d'Azur, France",
        birthday: Faker::Date.birthday(min_age: 18, max_age: 100),
        gender: "femme",
        gender_criteria: Faker::Gender.binary_type,
        hair: Faker::Color.color_name,
        eye: Faker::Color.color_name,
        smoke: Faker::Boolean.boolean,
        want_child: Faker::Boolean.boolean,
        lives_alone: Faker::Boolean.boolean,
        shape: "fine",
        goal: "relation sérieuse",
        min_age: Faker::Number.between(from: 18, to: 40),
        max_age: Faker::Number.between(from: 41, to: 75),
        perimeter_criteria: Faker::Number.between(from: 0, to: 1000),
        shape_criteria: ["normale", "kg en trop"],
        online: Faker::Boolean.boolean
      })
      # user.avatar.attach(io: file, filename: "#{Faker::Name.first_name}.jpeg", content_type: 'image/jpeg')
      user.save
  end

  (1..5).each do |id|
      # file = URI.open("#{Faker::Avatar.image(slug: "my-own-slug", size: "100x100", format: "jpg")}")
      user = User.new({
        email: Faker::Internet.email,
        password: "password",
        password_confirmation: "password",
        pseudo: Faker::Internet.username,
        address: "3 Rue Albert Dubout, Marseille 8e Arrondissement, Provence-Alpes-Côte d'Azur, France",
        birthday: Faker::Date.birthday(min_age: 18, max_age: 100),
        gender: "homme",
        gender_criteria: Faker::Gender.binary_type,
        hair: Faker::Color.color_name,
        eye: Faker::Color.color_name,
        smoke: Faker::Boolean.boolean,
        want_child: Faker::Boolean.boolean,
        lives_alone: Faker::Boolean.boolean,
        shape: "sportive",
        goal: "relation d'un soir",
        min_age: Faker::Number.between(from: 18, to: 30),
        max_age: Faker::Number.between(from: 41, to: 75),
        perimeter_criteria: Faker::Number.between(from: 0, to: 1000),
        shape_criteria: ["fine"],
        online: Faker::Boolean.boolean
      })
      # user.avatar.attach(io: file, filename: "#{Faker::Name.first_name}.jpeg", content_type: 'image/jpeg')
      user.save
  end


  puts "#{User.count} users generated"


  puts 'generating favorites'


  (1..3).each do |id|
    Favorite.create(
      user_id: user1.id,
      profile_id: User.all[-id].id
    )
  end


  puts 'generating publications'


  (1..3).each do |id|
    Publication.create(
      user_id: user1.id,
      content: "message test #{id}"
    )
  end


  puts 'generating contact requests'


  (1..5).each do |id|
    ContactRequest.create(
      receiver_id: user1.id,
      sender_id: User.all[-id].id
    )
  end


  puts 'generating notifications'


  (1..5).each do |id|
    Notification.create(
      receiver_id: user1.id,
      sender_id: User.all[-id].id,
      content: "message test #{id}"
    )
  end

  # (1..2).each do |id|
  #   Notification.create(
  #     sender_id: user1.id,
  #     receiver_id: User.last.id,
  #     content: "message test #{id}"
  #   )
  # end


  puts 'generating blockages'


  Blockage.create(initiator: user1, target: User.all[-7])


  puts 'generating chatrooms'


  chatroom1 = Chatroom.create(speaker1: user1, speaker2: user2)
  chatroom2 = Chatroom.create(speaker1: user1, speaker2: User.last)


  puts 'generating posts'


  Post.create(chatroom: chatroom1, user: user1, content: 'Salut toi !')


  puts 'generating orders'


  order1 = Order.create(state: 'payé', user: user1, amount_cents: 500, order_type: 'unique', duration: '1 semaine', active: false, paid_date: Date.today - 5.months, cancel_date: Date.today - 5.months + 1.week)
  order2 = Order.create(state: 'payé', user: user1, amount_cents: 1500, order_type: 'unique', duration: '1 mois', active: false, paid_date: Date.today - 4.months, cancel_date: Date.today - 4.months)
  order3 = Order.create(state: 'payé', user: user1, amount_cents: 1200, order_type: 'abonnement', duration: '3 mois minimum', active: true, paid_date: Date.today - 3.months, invoices_number: 3)
  order4 = Order.create(state: 'payé', user: user1, amount_cents: 150, order_type: 'caméra', camera_credits: 3, active: false, paid_date: Date.today)
  order5 = Order.create(state: 'payé', user: user2, amount_cents: 150, order_type: 'caméra', camera_credits: 3, active: false, paid_date: Date.today)


  puts 'generating payment_intents'


  # unique
  PaymentIntent.create(order: order1, payment_intent_id: 'pi_aaaaaaaa', amount_cents: order1.amount_cents)
  PaymentIntent.create(order: order2, payment_intent_id: 'pi_bbbbbbbb', amount_cents: order2.amount_cents)
  PaymentIntent.create(order: order3, payment_intent_id: 'pi_cccccccc1', amount_cents: order3.amount_cents)
  PaymentIntent.create(order: order4, payment_intent_id: 'pi_dddddddd', amount_cents: order4.amount_cents)
  PaymentIntent.create(order: order5, payment_intent_id: 'pi_eeeeeeee', amount_cents: order5.amount_cents)

  # abonnement
  PaymentIntent.create(order: order3, payment_intent_id: 'pi_cccccccc2', amount_cents: order3.amount_cents)
  PaymentIntent.create(order: order3, payment_intent_id: 'pi_cccccccc3', amount_cents: order3.amount_cents)


  # puts 'generating games'


  # game
  # Game.create(player1: user1, player2: user2)


  puts 'generating pages'


  Page.create(tag: 'accueil')

  # Page.create(
  #   tag: 'accueil',
  #   title: 'Site de rencontre valorisant les personnes handicapées',
  #   quote: "“Le principal handicap de l'homme, c'est de vouloir être à tout prix le meilleur
  #   en sachant pertinemment que le meilleur reste à venir...
  #   Alors, pourquoi partir ?” - De Phil Umbdenstock",
  #   content: "Sunryse est accessible à toutes personnes, quelles que soient leurs qualités et défauts, valides ou invalides.
  #
  #   Ce site a pour but à ce que les personnes en situation de handicap, trouvent aussi l’amour ou l'amitié, avec l’acceptation de l’autre.
  #
  #   Il est composé d'un mur de publication, de stories, d'un système de géolocalisation en temps réel et d'une caméra en messagerie.
  #
  #   Les tarifs sont minimisés : gratuit pour les femmes et variables pour les hommes, à partir de 10 € par mois. Voir les détails dans les Conditions Générales de Vente
  #
  #   Soyez la bienvenue chez Sunryse, un nouveau départ vous attend !"
  # )


  puts "Done!"

end
