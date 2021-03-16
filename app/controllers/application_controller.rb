class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Api::CreateUploadedfile
end
