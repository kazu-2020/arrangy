class ArrangementForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :arrangement

  attribute :title, :string
  attribute :context, :string
  attribute :images
  attribute :taste, :integer, default: 3
  attribute :spiciness, :integer, default: 3
  attribute :sweetness, :integer, default: 3
  attribute :satisfaction, :integer, default: 3

  validates :title, length: { maximum: 30 }
  validates :context, length: { maximum: 1000 }
  validate  :validate_model

  with_options numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 } do
    validates :taste
    validates :spiciness
    validates :sweetness
    validates :satisfaction
  end

  def initialize(arrangement: Arrangement.new, arrangement_params: {}, parameter_params: {})
    @arrangement = arrangement
    @arrangement.assign_attributes(arrangement_params)
    @parameter = arrangement.new_record? ? arrangement.build_parameter : arrangement.parameter
    @parameter.assign_attributes(parameter_params)
    super(arrangement_params.merge(parameter_params))
  end

  def save!
    raise ActiveRecord::RecordInvalid unless valid?

    ActiveRecord::Base.transaction do
      @arrangement.save!
      @parameter.save!
    end
  end

  private

  def validate_model
    promote_errors(@arrangement.errors) unless @arrangement.valid?
    promote_errors(@parameter.errors) unless @parameter.valid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end