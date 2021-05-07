class UpdatePasswordForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include CryptedPassword

  attribute :password, :string
  attribute :password_confirmation, :string

  def initialize(user: User.new, params: {})
    @user = user
    super(params)
  end

  def save!
    raise ActiveRecord::RecordInvalid unless valid?

    @user.change_password!(password)
  end
end
