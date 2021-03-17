class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # rubocop:disable Metrics/AbcSize
  def store_dir
    if Rails.env.test?
      "#{Rails.root}/spec/fixtures/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
  # rubocop:enable Metrics/AbcSize

  def size_range
    0.byte..10.megabytes
  end

  # vue側と統一
  process resize_to_fill: [300, 300, 'Center']
  process convert: 'png'

  def extension_allowlist
    %w[jpg jpeg png gif]
  end
end
