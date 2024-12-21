class PersonalPhoto < ApplicationRecord
  has_one_attached :photo
  has_one_attached :icon

  validates :name, presence: true, length: { maximum: 50 }
  validates :photo, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 10.megabytes }
  validates :icon, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], aspect_ratio: :square, size: { less_than: 10.megabytes }
end
