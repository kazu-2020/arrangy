require 'rails_helper'
require 'carrierwave/test/matchers'

describe 'ImageUploader' do
  describe 'バリデーション機能' do
    let(:arrangement) { build(:arrangement) }

    describe '拡張子のホワイトリストの検証' do
      context 'jpg, jpeg, png, gifの場合' do
        extensions = %w[jpg jpeg png gif]
        it 'ファイルは有効です' do
          extensions.each do |extension|
            File.open("#{Rails.root}/spec/fixtures/images/sample1.#{extension}") do |file|
              arrangement.images = [file]
            end
            expect(arrangement).to be_valid
          end
        end
      end

      context 'txtの場合' do
        it 'ファイルは無効です' do
          File.open("#{Rails.root}/spec/fixtures/images/sample1.txt") do |file|
            arrangement.images = [file]
          end
          expect(arrangement).to be_invalid
        end
      end
    end

    describe 'ファイルサイズの検証' do
      context 'ファイルサイズが10MBより大きい場合' do
        it 'ファイルは無効です' do
          File.open("#{Rails.root}/spec/fixtures/images/15MB.jpg") do |file|
            arrangement.images = [file]
          end
          expect(arrangement).to be_invalid
        end
      end
    end
  end

  describe '画像加工機能' do
    include CarrierWave::Test::Matchers

    let(:arrangement) { Arrangement.new }
    # 第一引数 => モデルのインスタンス指定, 第二引数 => マウントするカラムを指定
    # モデルのインスタンスが無いとファイルを保存する際、pathを探せずにerrorを吐く
    let(:uploader) { ImageUploader.new(arrangement, :images) }

    before do
      # ファイルの加工を許可する
      ImageUploader.enable_processing = true
      File.open("#{Rails.root}/spec/fixtures/images/sample1.jpg") do |file|
        uploader.store!(file)
      end
    end

    after do
      ImageUploader.enable_processing = false
      uploader.remove!
    end

    describe '拡張子変換機能' do
      it 'jpgがpngに変換されている' do
        expect(uploader).to be_format('png')
      end
    end

    describe 'リサイズ機能' do
      it 'size 300 x 300 にリサイズされている' do
        expect(uploader).to have_dimensions(300, 300)
      end
    end
  end
end