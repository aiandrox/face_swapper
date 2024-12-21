class ProcessedPhoto < ApplicationRecord
  belongs_to :original_photo

  has_one_attached :photo

  validates :photo, attached: true, processable_image: true
end
