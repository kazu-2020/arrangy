module Api
  module Oauth
    class CallbacksController < ApplicationController
      skip_before_action :require_login
      before_action :confirm_regisered_user, only: :show

      def show
        oauth_form = OauthForm.new(user: user, oauth_params: oauth_params)
        if oauth_form.save
          auto_login(oauth_form.user, true)
          redirect_to root_path(registration: true)
        else
          session[:oauth_params] = oauth_params
          redirect_to reregister_url
        end
      end

      private

      def confirm_regisered_user
        return redirect_to '/login' if params[:denied].present?
        return redirect_to root_path if login_from(params[:provider], true)
      end

      def user
        @_user ||= build_from(params[:provider])
      end

      def oauth_params
        # @user_hash内にユーザー情報が代入されている
        @user_hash.slice(:uid).merge(provider: params[:provider])
      end

      def reregister_url
        "/reregister?nickname=#{user.nickname}&email=#{user.email}"
      end
    end
  end
end
