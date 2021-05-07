module Api
  class OauthsController < ApplicationController
    skip_before_action :require_login

    def show
      login_at(params[:provider])
    end
  end
end
