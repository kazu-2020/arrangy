class ApplicationController < ActionController::Base
  before_action :require_login
  after_action :set_csrf_token

  include Api::Base64Converting
  include Api::CreateUploadedfile
  include Api::ExceptionHandring
  include Pagy::Backend

  private

  def set_csrf_token
    response.headers['X-CSRF-TOKEN'] = form_authenticity_token
  end

  def not_authenticated
  end
end
