Aws.config.update({
  region: Rails.application.credentials.dig(:aws, :region),
  credentials: Aws::Credentials.new( Rails.application.credentials.dig(:aws, :access_key_id), Rails.application.credentials.dig(:aws, :secret_access_key))
})

S3_BUCKET = Aws::S3::Resource.new.bucket(Settings.dig(:aws, :bucket))
