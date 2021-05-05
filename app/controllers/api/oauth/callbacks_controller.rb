module Api
  module Oauth
    class CallbacksController < ApplicationController
      skip_before_action :require_login

      def show # rubocop:disable Metrics/AbcSize
        return redirect_to root_path if login_from(params[:provider])

        oauth_form = OauthForm.new(user: build_from(params[:provider]), oauth_params: oauth_params)

        if oauth_form.save
          auto_login(oauth_form.user)
          redirect_to root_path(registration: true)
        else
          session[:oauth_params] = oauth_params
          redirect_to reregister_url
        end
      end

      private

      def oauth_params
        @user_hash.slice(:uid).merge(provider: params[:provider])
      end

      def reregister_url
        "/reregister?nickname=#{@user_hash[:user_info]['name']}&email=#{@user_hash[:user_info]['email']}"
      end
    end
  end
end
