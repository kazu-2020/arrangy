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

  # vue側と統一
  process resize_to_fill: [300, 300, 'Center']
  process convert: 'png'

  # 拡張子のホワイトリスト
  def extension_allowlist
    %w[jpg jpeg png gif]
  end
end
