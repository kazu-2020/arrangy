class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # アップロードされたファイルの保存先(storage :fileの場合)
  # rubocop:disable Metrics/AbcSize
  def store_dir
    if Rails.env.test?
      "#{Rails.root}/spec/fixtures/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
  # rubocop:enable Metrics/AbcSize

  # 画像サイズのバリデーション(https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Validate-image-file-size)
  def size_range
    0.byte..10.megabytes
  end

  # vue側と統一
  process resize_to_fill: [300, 300, 'Center']
  process convert: 'png'

  # 拡張子のホワイトリスト
  def extension_allowlist
    %w[jpg jpeg png]
  end
end
