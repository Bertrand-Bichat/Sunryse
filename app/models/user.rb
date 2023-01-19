class User < ApplicationRecord
  # SEO
  extend FriendlyId
  friendly_id :pseudo, use: [:slugged, :finders]

  # serach bar
  include PgSearch::Model
  pg_search_scope :search_full_text_1,
    against: {
      pseudo: 'A',
      city_geocoded: 'B',
      introduction: 'C',
      description: 'D'
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
  pg_search_scope :search_full_text_2,
    against: {
      job: 'A',
      qualities: 'B',
      defaults: 'C',
      i_want: 'D'
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
  pg_search_scope :search_full_text_3,
    against: {
      i_dont_want: 'A',
      beliefs: 'B',
      projects: 'C',
      movies: 'D'
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
  pg_search_scope :search_full_text_4,
    against: {
      books: 'A',
      hobbies: 'B'
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  # DEVISE
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :validatable

  # Active Record
  has_many :favorites, dependent: :destroy
  has_many :publications, dependent: :destroy
  has_many :sent_contact_requests, class_name: 'ContactRequest', foreign_key: "sender_id", dependent: :destroy
  has_many :received_contact_requests, class_name: 'ContactRequest', foreign_key: "receiver_id", dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification', foreign_key: "sender_id", dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: "receiver_id", dependent: :destroy
  has_many :initiated_blockages, class_name: 'Blockage', foreign_key: "initiator_id", dependent: :destroy
  has_many :targeted_blockages, class_name: 'Blockage', foreign_key: "target_id", dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :speaker1_chatrooms, class_name: 'Chatroom', foreign_key: "speaker1_id", dependent: :destroy
  has_many :speaker2_chatrooms, class_name: 'Chatroom', foreign_key: "speaker2_id", dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :player1_games, class_name: 'Game', foreign_key: "player1_id", dependent: :destroy
  has_many :player2_games, class_name: 'Game', foreign_key: "player2_id", dependent: :destroy

  # Active Storage
  has_one_attached :avatar
  has_many_attached :photos
  has_many_attached :stories

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :pseudo, presence: true, uniqueness: true

  validates :address, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true
  validates :hair, presence: true
  validates :eye, presence: true
  validates :shape, presence: true
  validates :gender_criteria, presence: true
  validates :goal, presence: true

  validates :introduction, length: { maximum: 500, too_long: "la phrase d'introduction doit faire %{count} caractères maximum" }

  validates :min_age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 18, less_than_or_equal_to: :max_age }
  validates :max_age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: :min_age, less_than_or_equal_to: 100 }
  validates :perimeter_criteria, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :ninja_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30 }
  validates :camera_credits_balance, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :avatar,
            size: { less_than: 10.megabytes, message: 'image ou vidéo de 10 Mo ou moins' },
            content_type: { in: ApplicationController.helpers.video_img_choice, message: 'Veuillez utiliser une image (PNG, JPG, JPEG) ou une vidéo (MP4)' }

  validates :photos,
            size: { less_than: 1.megabytes, message: 'images de 1 Mo chacune ou moins' },
            limit: { min: 0, max: 10, message: '10 images maximum' },
            content_type: { in: ApplicationController.helpers.img_choice, message: 'Veuillez utiliser des images PNG, JPG ou JPEG' }

  validates :stories,
            size: { less_than: 10.megabytes, message: 'image ou vidéo de 10 Mo chacun ou moins' },
            content_type: { in: ApplicationController.helpers.video_img_choice, message: 'Veuillez utiliser une image (PNG, JPG, JPEG) ou une vidéo (MP4)' }

  # Geocoder
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  before_save :find_city

  # Authorize user to access all the website at every account modifications
  before_save :set_authorization

  # Mailer
  after_create :send_welcome_email

  def age
    (Date.today - birthday).to_i / 365 if birthday
  end

  private

  def find_city
    address = Geocoder.search("#{latitude},#{longitude}")&.first if latitude && longitude
    user_location = "#{address&.city} (#{address&.postal_code})"
    self.city_geocoded = user_location if user_location
  end

  def send_welcome_email
    if Rails.env == "production"
      UserMailer.with(user: self).notification_welcome.deliver_later
    end
  end

  def set_authorization
    if (admin == true) && (authorized == false)
      self.authorized = true
    elsif gender && (gender == ApplicationController.helpers.female)
      self.authorized = true
    elsif gender && (gender == ApplicationController.helpers.male)
      active_order = Order.find_by(user: self, active: true)
      if active_order.present?
        self.authorized = true
      else
        self.authorized = false
      end
    end
  end
end
