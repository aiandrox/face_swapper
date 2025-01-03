class Compare
  def initialize(original_photo:)
    @rekognition_client = AwsClient.rekognition
    @s3_client = AwsClient.s3
    @original_photo = original_photo
    @bucket_name = "face-swapper-bucket-#{Rails.env}"
  end

  def compare_face_image
    s3_original_photo = @s3_client.get_object(bucket: @bucket_name, key: @original_photo.photo.key)
    image = MiniMagick::Image.read(s3_original_photo.body)
    width, height = image.dimensions

    PersonalPhoto.find_each do |personal_photo|
      attrs = {
        source_image: {
          s3_object: {
            bucket: @bucket_name,
            name: personal_photo.photo.key
          }
        },
        target_image: {
          s3_object: {
            bucket: @bucket_name,
            name: @original_photo.photo.key
          }
        },
        similarity_threshold: 80
      }
      response = @rekognition_client.compare_faces attrs
      next if response.face_matches.blank?

      s3_icon = @s3_client.get_object(bucket: @bucket_name, key: personal_photo.icon.key)
      icon = MiniMagick::Image.read(s3_icon.body)

      response.face_matches.each do |face_match|
        position = face_match.face.bounding_box
        image.combine_options do |c|
          icon_height = height * position.height
          icon_width = icon_height
          face_position_top = position.top * height
          face_center = position.left + position.width / 2
          face_position_left = face_center * width - icon_width / 2
          c.draw "image Over #{face_position_left},#{face_position_top} #{icon_width},#{icon_height} '#{icon.path}'"
        end
      end
    end

    image
  end
end
