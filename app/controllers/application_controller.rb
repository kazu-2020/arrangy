class ApplicationController < ActionController::Base
  before_action :require_login

  include Pagy::Backend
  include Api::CreateUploadedfile
end
