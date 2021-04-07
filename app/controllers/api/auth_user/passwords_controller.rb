module Api
  module AuthUser
    class PasswordsController < ApplicationController
      def update
        current_user.password_confirmation = params[:password_confirmation]
        current_user.change_password!(params[:password])
        head :no_content
      end
    end
  end
end
