class ProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Nickname
  include Email

  attribute :nickname, :string
  attribute :email, :string
  attribute :avatar

  validate :validate_model

  def initialize(user: User.new, params: {})
    @user = user
    @user.assign_attributes(params)
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