class ApplicationController < ActionController::Base
  before_action :require_login

  include Pagy::Backend
  include Api::CreateUploadedfile
  include Api::ExceptionHandring

  private

  def not_authenticated
    render_400(nil, 'ログインしてください')
  end
end
