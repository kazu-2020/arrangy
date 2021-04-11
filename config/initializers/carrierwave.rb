CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.enable_processing = true
  elsif Rails.env.development?
    config.storage = :file
    config.enable_processing = true
  else
    config.storage = :file
    config.enable_processing = false
  end

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: Rails.application.credentials.dig(:aws, :region)
  }
  config.fog_directory  = 'arrangy'
end
