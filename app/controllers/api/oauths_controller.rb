module Api
  class OauthsController < ApplicationController
    skip_before_action :require_login

    def oauth
      login_at(params[:provider])
    end

    def callback
      return redirect_to root_path if login_from(params[:provider])

      begin
        user = create_from(params[:provider])
        reset_session
        auto_login(user)
        redirect_to root_path
      rescue StandardError
        redirect_to root_path
      end
    end
  end
end
