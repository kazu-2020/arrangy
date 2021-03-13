class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def size_range
    0.byte..10.megabytes
  end

  def default_url(*args)
    "/images/" + [version_name, "default_avatar.png"].compact.join('_')
  end

  #vue側と統一
  process resize_to_fill: [300, 300, 'Center']
  process convert: 'png'

  # 拡張子のホワイトリスト
  def extension_allowlist
    %w[jpg jpeg png gif]
  end
end
