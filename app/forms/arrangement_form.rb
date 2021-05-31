class ArrangementForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :arrangement

  attribute :title, :string
  attribute :context, :string
  attribute :rating, :integer
  attribute :arrange_level, :integer
  attribute :after_arrangement_photo_url, :string
  attribute :before_arrangement_photo_url, :string

  validate  :validate_model
  validates :title, length: { maximum: 30 }
  validates :context, length: { maximum: 1000 }
  with_options numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 } do
    validates :rating
  end

  # rubocop:disable all
  def initialize(arrangement: Arrangement.new,
                 arrangement_params: {},
                 after_arrangement_photo_params: {},
                 before_arrangement_photo_params: {})
    @arrangement = arrangement
    @arrangement.assign_attributes(arrangement_params)
    @after_arrangement_photo, @before_arrangement_photo = if arrangement.new_record?
                                                            [arrangement.build_after_arrangement_photo,
                                                             arrangement.build_before_arrangement_photo]
                                                          else
                                                            [arrangement.after_arrangement_photo,
                                                             arrangement.before_arrangement_photo]
                                                          end
    @after_arrangement_photo.assign_attributes(after_arrangement_photo_params)
    @before_arrangement_photo.assign_attributes(before_arrangement_photo_params)
    super(arrangement_params.merge(
      after_arrangement_photo_url: after_arrangement_photo_params[:url], before_arrangement_photo_url: before_arrangement_photo_params[:url]
    ))
  end

  def save!
    raise ActiveRecord::RecordInvalid unless valid?

    ActiveRecord::Base.transaction do
      @arrangement.save!
      @after_arrangement_photo.save!
      @before_arrangement_photo.save!
    end
  end

  private

  def validate_model
    promote_errors(@arrangement.errors) unless @arrangement.valid?
    promote_errors(@after_arrangement_photo.errors) unless @after_arrangement_photo.valid?
    promote_errors(@before_arrangement_photo.errors) unless @before_arrangement_photo.valid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
