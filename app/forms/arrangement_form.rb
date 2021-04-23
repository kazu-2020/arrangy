class ArrangementForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :arrangement

  attribute :title, :string
  attribute :context, :string
  attribute :images
  attribute :taste, :integer
  attribute :spiciness, :integer
  attribute :sweetness, :integer
  attribute :satisfaction, :integer

  validates :title, presence: true, length: { maximum: 30 }
  validates :context, presence: true, length: { maximum: 1000 }
  validates :images, presence: true

  with_options presence: true,
               numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 } do
    validates :taste
    validates :spiciness
    validates :sweetness
    validates :satisfaction
  end

  def initialize(arrangement: {}, arrangement_params: {}, parameter_params: {})
    @arrangement = arrangement
    @arrangement.assign_attributes(arrangement_params)
    @parameter_params = parameter_params
    super(arrangement_params.merge(parameter_params))
  end

  def save!
    raise ActiveRecord::RecordInvalid unless valid?

    ActiveRecord::Base.transaction do
      @arrangement.save!
      @arrangement.create_parameter!(@parameter_params)
    end
  end
end
