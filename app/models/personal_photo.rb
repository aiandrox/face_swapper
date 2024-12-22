class PersonalPhoto < ApplicationRecord
  has_one_attached :photo
  has_one_attached :icon

  validates :name, presence: true, length: { maximum: 50 }
  validates :photo, attached: true, processable_image: true, content_type: [ :png, :jpg, :jpeg ], size: { less_than: 10.megabytes }
  validates :icon, processable_image: true, content_type: [ :png, :jpg, :jpeg ], aspect_ratio: :square, size: { less_than: 10.megabytes }

  def self.process_icon(uploaded_file)
    icon_image = MiniMagick::Image.read(uploaded_file.tempfile)
    MiniMagick::Tool::Convert.new do |img|
      img.size "#{icon_image.height}x#{icon_image.width}"
      img << "xc:transparent"
      img.fill icon_image.path
      img.draw "translate #{icon_image.height/2}, #{icon_image.width/2} circle 0,0 #{icon_image.width/2},0"
      img.trim
      img << "png:-"
    end
  end
end
