class ApplicationController < ActionController::Base
  before_action :require_login

  include Api::Base64Converting
  include Api::CreateUploadedfile
  include Api::ExceptionHandring
  include Pagy::Backend

  private

  def not_authenticated
    render_400(nil, 'ログインしてください')
  end
end
