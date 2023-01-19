class Page < ApplicationRecord
  has_one_attached :main_logo
  has_one_attached :navbar_logo
  has_one_attached :background_photo
  has_one_attached :favicon

  validates :tag, presence: true, uniqueness: true

  validates :main_logo,
            dimension: { width: 200, message: 'doit faire 200 pixels de large' },
            size: { less_than: 50.kilobytes, message: 'image de 50 Ko ou moins' },
            content_type: { in: ApplicationController.helpers.img_choice, message: 'Veuillez utiliser une image (PNG, JPG, JPEG)' }
  validates :navbar_logo,
            dimension: { width: 110, message: 'doit faire 110 pixels de large' },
            size: { less_than: 20.kilobytes, message: 'image de 20 Ko ou moins' },
            content_type: { in: ApplicationController.helpers.img_choice, message: 'Veuillez utiliser une image (PNG, JPG, JPEG)' }
  validates :background_photo,
            size: { less_than: 1.megabytes, message: 'image de 1 Mo ou moins' },
            content_type: { in: ApplicationController.helpers.img_choice, message: 'Veuillez utiliser une image (PNG, JPG, JPEG)' }
  validates :favicon,
            dimension: { width: 16, height: 16, message: 'doit faire 16x16 pixels de dimension' },
            size: { less_than: 10.kilobytes, message: 'image de 10 Ko ou moins' },
            content_type: { in: ApplicationController.helpers.ico_content_type, message: 'Veuillez utiliser une image au format .ico' }
end
