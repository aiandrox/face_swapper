class OriginalPhoto < ApplicationRecord
  has_one_attached :photo
  has_one_attached :processed_photo

  validates :photo, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 10.megabytes }

  def exec_rekognition
    image = Compare.new(original_photo: self).compare_face_image
    processed_photo.attach(
      io: StringIO.new(image.to_blob),
      filename: "#{photo.filename.split('.')[0]}_#{Time.now.strftime('%Y%m%d%H%M%S')}.png",
      content_type: "image/png"
    )
  end
end
