Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.breadcrumbs_logger = [:active_support_logger]

  # ユーザIP、クッキーなどの個人を特定できる情報を送信したい場合はtrueにする
  config.send_default_pii = false

  config.excluded_exceptions += %w[ActiveRecord::RecordNotFound]

  config.environment = 'production'

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 0.5
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end