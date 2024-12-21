module AwsClient
  def self.rekognition
    @rekognition ||= Aws::Rekognition::Client.new(
      credentials: Aws::Credentials.new(
        Rails.application.credentials.dig(:aws, :access_key_id),
        Rails.application.credentials.dig(:aws, :secret_access_key)
      ),
      region: "ap-northeast-1"
    )
  end

  def self.s3
    @s3 ||= Aws::S3::Client.new(
      credentials: Aws::Credentials.new(
        Rails.application.credentials.dig(:aws, :access_key_id),
        Rails.application.credentials.dig(:aws, :secret_access_key)
      ),
      region: "ap-northeast-1"
    )
  end
end
