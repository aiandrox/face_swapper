class OriginalPhoto < ApplicationRecord
  has_one_attached :photo

  validates :photo, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 10.megabytes }
end
