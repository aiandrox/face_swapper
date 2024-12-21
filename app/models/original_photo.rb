class OriginalPhoto < ApplicationRecord
  has_one :processed_photo, dependent: :destroy
  has_one_attached :photo

  validates :photo, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 10.megabytes }


  def process_photo
    client = Rekognition.client
    image = Compare.new(client: client, photo: self)
  end
end
