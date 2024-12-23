class OriginalPhoto < ApplicationRecord
  before_create -> { self.uuid = SecureRandom.uuid }

  has_one_attached :photo
  has_one_attached :processed_photo

  validates :uuid, presence: true, uniqueness: true
  validates :photo, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 10.megabytes }

  def exec_rekognition
    image = Compare.new(original_photo: self).compare_face_image
    filename = "#{photo.filename.to_s.split('.')[0]}_#{Time.now.strftime('%Y%m%d%H%M%S')}.png"
    processed_photo.attach(
      io: StringIO.new(image.to_blob),
      filename:,
      content_type: "image/png"
    )
  end

  def to_param
    uuid
  end
end
