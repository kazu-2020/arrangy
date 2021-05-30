Rails.application.config.sorcery.submodules = %i[reset_password external remember_me]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|
  # -- core --
  # What controller action to call for non-authenticated users. You can also
  # override the 'not_authenticated' method of course.
  config.not_authenticated_action = :not_authenticated

  # When a non logged-in user tries to enter a page that requires login, save
  # the URL he wants to reach, and send him there after login, using 'redirect_back_or_to'.
  config.save_return_to_url = true

  # Set domain option for cookies; Useful for remember_me submodule.
  config.cookie_domain = nil

  # Allow the remember_me cookie to be set through AJAX
  config.remember_me_httponly = true

  # -- external --
  config.external_providers = [:google, :twitter]

  # You can change it by your local ca_file. i.e. '/etc/pki/tls/certs/ca-bundle.crt'
  # Path to ca_file. By default use a internal ca-bundle.crt.
  config.ca_file = 'path/to/ca_file'

  # Twitter will not accept any requests nor redirect uri containing localhost,
  # Make sure you use 0.0.0.0:3000 to access your app in development
  config.twitter.key = Rails.application.credentials.dig(:twitter, :access_key_id)
  config.twitter.secret = Rails.application.credentials.dig(:twitter, :secret_access_key)
  config.twitter.callback_url = Settings.dig(:twitter, :callback_url)
  config.twitter.user_info_path = '/1.1/account/verify_credentials.json?include_email=true'
  config.twitter.user_info_mapping = {nickname: "screen_name", email: "email"}

  config.google.key = Rails.application.credentials.dig(:google, :access_key_id)
  config.google.secret = Rails.application.credentials.dig(:google, :secret_access_key)
  config.google.callback_url = Settings.dig(:google, :callback_url)
  config.google.user_info_mapping = {:email => "email", :nickname => "name"}
  # config.google.scope = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"

  # config.facebook.key = ""
  # config.facebook.secret = ""
  # config.facebook.callback_url = "http://0.0.0.0:3000/oauth/callback?provider=facebook"
  # config.facebook.user_info_path = "me?fields=email"
  # config.facebook.user_info_mapping = {:email => "email"}
  # config.facebook.access_permissions = ["email"]
  # config.facebook.display = "page"
  # config.facebook.api_version = "v2.3"
  # config.facebook.parse = :json

  # --- user config ---
  config.user_config do |user|
    # -- core --
    # Specify username attributes, for example: [:username, :email].
    user.username_attribute_names = %i[email]

    # Change *virtual* password attribute, the one which is used until an encrypted one is generated.
    user.password_attribute_name = :password

    # Downcase the username before trying to authenticate, default is false
    user.downcase_username_before_authenticating = false

    # Change default email attribute.
    user.email_attribute_name = :email

    # Change default crypted_password attribute.
    user.crypted_password_attribute_name = :crypted_password

    # What pattern to use to join the password with the salt
    user.salt_join_token = ''

    # Change default salt attribute.
    user.salt_attribute_name = :salt

    # How many times to apply encryption to the password.
    # Default: 1 in test env, `nil` otherwise
    #
    user.stretches = 1 if Rails.env.test?

    # Encryption key used to encrypt reversible encryptions such as AES256.
    # WARNING: If used for users' passwords, changing this key will leave passwords undecryptable!
    user.encryption_key = nil

    # Use an external encryption class.
    user.custom_encryption_provider = nil

    # Encryption algorithm name. See 'encryption_algorithm=' for available options.
    user.encryption_algorithm = :bcrypt

    # Make this configuration inheritable for subclasses. Useful for ActiveRecord's STI.
    user.subclasses_inherit_config = false

    # -- remember_me --
    # How long in seconds the session length will be
    # Default: `60 * 60 * 24 * 7`
    user.remember_me_for = 60 * 60 * 24 * 365

    # When true, sorcery will persist a single remember me token for all
    # logins/logouts (to support remembering on multiple browsers simultaneously).
    user.remember_me_token_persist_globally = false

    # -- user_activation --
    # The attribute name to hold activation state (active/pending).
    # Default: `:activation_state`
    #
    # user.activation_state_attribute_name =

    # The attribute name to hold activation code (sent by email).
    # Default: `:activation_token`
    #
    # user.activation_token_attribute_name =

    # The attribute name to hold activation code expiration date.
    # Default: `:activation_token_expires_at`
    #
    # user.activation_token_expires_at_attribute_name =

    # How many seconds before the activation code expires. nil for never expires.
    # Default: `nil`
    #
    # user.activation_token_expiration_period =

    # REQUIRED:
    # User activation mailer class.
    # user.user_activation_mailer = nil

    # When true, sorcery will not automatically
    # send the activation details email, and allow you to
    # manually handle how and when the email is sent.
    # Default: `false`
    #
    # user.activation_mailer_disabled =

    # Method to send email related
    # options: `:deliver_later`, `:deliver_now`, `:deliver`
    # Default: :deliver (Rails version < 4.2) or :deliver_now (Rails version 4.2+)
    #
    # user.email_delivery_method =

    # Activation needed email method on your mailer class.
    # Default: `:activation_needed_email`
    #
    # user.activation_needed_email_method_name =

    # Activation success email method on your mailer class.
    # Default: `:activation_success_email`
    #
    # user.activation_success_email_method_name =

    # Do you want to prevent users who did not activate by email from logging in?
    # Default: `true`
    #
    # user.prevent_non_active_users_to_login =

    # -- reset_password --
    # Password reset token attribute name.
    user.reset_password_token_attribute_name = :reset_password_token

    # Password token expiry attribute name.
    user.reset_password_token_expires_at_attribute_name = :reset_password_token_expires_at

    # When was password reset email sent. Used for hammering protection.
    user.reset_password_email_sent_at_attribute_name = :reset_password_email_sent_at

    # REQUIRED:
    # Password reset mailer class.
    user.reset_password_mailer = UserMailer

    # Reset password email method on your mailer class.
    user.reset_password_email_method_name = :reset_password_email

    # When true, sorcery will not automatically
    # send the password reset details email, and allow you to
    # manually handle how and when the email is sent
    user.reset_password_mailer_disabled = false

    # How many seconds before the reset request expires. nil for never expires.
    user.reset_password_expiration_period = 1.hour

    # Hammering protection: how long in seconds to wait before allowing another email to be sent.
    # Default: `5 * 60`
    user.reset_password_time_between_emails = 5 * 60

    # Access counter to a reset password page attribute name
    user.reset_password_page_access_count_attribute_name = :access_count_to_reset_password_page

    # -- external --
    # Class which holds the various external provider data for this user.
    user.authentications_class = Authentication

    # User's identifier in the `authentications` class.
    user.authentications_user_id_attribute_name = :user_id

    # Provider's identifier in the `authentications` class.
    user.provider_attribute_name = :provider

    # User's external unique identifier in the `authentications` class.
    user.provider_uid_attribute_name = :uid
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = "User"
end
