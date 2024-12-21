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
            name: @original_photo.photo.key
          }
        },
        target_image: {
          s3_object: {
            bucket: @bucket_name,
            name: personal_photo.photo.key
          }
        },
        similarity_threshold: 80
      }
      response = @rekognition_client.compare_faces attrs
      face_matches = response.face_matches.each do |face_match|
        position   = face_match.face.bounding_box
        similarity = face_match.similarity
        puts "The face at: #{position.left}, #{position.top} matches with #{similarity} % confidence"
      end

      s3_icon = @s3_client.get_object(bucket: @bucket_name, key: personal_photo.icon.key)
      icon = MiniMagick::Image.read(s3_icon.body)

      face_matches.each do |face_match|
        position = face_match.face.bounding_box
        image.combine_options do |c|
          face_position_left = position.left * width
          face_position_top = position.top * height
          icon_width = width * position.width
          icon_height = height * position.height
          c.draw "image Over #{face_position_left},#{face_position_top} #{icon_width},#{icon_height} '#{icon}'"
        end
      end
    end

    image
  end
end
