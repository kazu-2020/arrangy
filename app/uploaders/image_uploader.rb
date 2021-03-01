class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # アップロードされたファイルの保存先(storage :fileの場合)
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 画像サイズのバリデーション(https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Validate-image-file-size)
  def size_range
    0.byte..10.megabytes
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # vue側と統一
  process resize_to_fit: [300, 300]
  process convert: 'png'
  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # 拡張子のホワイトリスト
  def extension_allowlist
    %w[jpg jpeg png gif]
  end
end
