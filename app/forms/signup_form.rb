class SignupForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Nickname
  include Email
  include CryptedPassword

  attr_reader :user

  attribute :nickname, :string
  attribute :email, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  validate :validate_model

  def initialize(params = {})
    @user = User.new(params)
    super(params)
  end

  def save!
    raise ActiveRecord::RecordInvalid unless valid?

    @user.save!
  end

  private

  def validate_model
    promote_errors(@user.errors) unless @user.valid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
