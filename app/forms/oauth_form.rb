class OauthForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Nickname
  include Email

  attr_reader :user

  attribute :nickname, :string
  attribute :email,    :string
  attribute :uid,      :integer
  attribute :provider, :string

  validate  :validate_model

  def initialize(user: User.new, oauth_params: {})
    @user = user
    @authentication = user.authentications.build(oauth_params)
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      @user.save!
      @authentication.save!
    end
    true
  end

  private

  def default_attributes
    {
      nickname: @user.nickname,
      email: @user.email,
      uid: @authentication.uid,
      provider: @authentication.provider
    }
  end

  def validate_model
    promote_errors(@user.errors) unless @user.valid?
    promote_errors(@authentication.errors) unless @authentication.valid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
