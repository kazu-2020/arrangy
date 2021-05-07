module Api
  module Oauth
    class ReregistersController < ApplicationController
      skip_before_action :require_login

      def create
        oauth_form = OauthForm.new(user: user, oauth_params: session[:oauth_params])
        raise ActiveRecord::RecordInvalid unless oauth_form.valid?

        oauth_form.save
        session[:oauth_params] = nil
        auto_login(oauth_form.user)
        options = { fields: { user: %i[nickname email avatar] } }
        json_string = UserSerializer.new(oauth_form.user, options)
        render json: json_string
      end

      private

      def user
        @_user ||= User.new(user_params)
      end

      def user_params
        params.require(:reregister).permit(:nickname, :email)
      end
    end
  end
end
