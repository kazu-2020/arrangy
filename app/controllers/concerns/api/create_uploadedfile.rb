module Api
  module CreateUploadedfile
    extend ActiveSupport::Concern

    def create_uploadedfile(encode_data, filename = 'arrangement_image')
      image_data = split_uri(encode_data)
      decode_data = Base64.decode64(image_data[:form_data])
      image_params = {
        filename: "#{filename}.#{image_data[:extension]}",
        type: image_data[:content_type],
        tempfile: create_tempfile(decode_data)
      }
      ActionDispatch::Http::UploadedFile.new(image_params)
    end

    private

    def split_uri(data)
      # decodeするにはdata:*/*;base64,を取り除く
      data =~ /^data:(.+);.+,(.+)$/
      uri = {}
      uri[:content_type] = Regexp.last_match(1)
      uri[:form_data] = Regexp.last_match(2)
      uri[:extension] = Regexp.last_match(1).split('/')[1]
      uri
    end

    # https://docs.ruby-lang.org/ja/2.3.0/class/Tempfile.html
    # 画像などのバイナリデータを書き込む時は、binmodeを使用する。
    def create_tempfile(data)
      Tempfile.open('imagefile') do |file|
        file.binmode
        file.write(data)
        file.rewind
        file
      end
    end
  end
end
