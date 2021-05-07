module Api
  module AuthUser
    class PasswordsController < ApplicationController
      def update
        password_form = UpdatePasswordForm.new(user: current_user, params: user_params)
        password_form.save!
        head :no_content
      end

      private

      def user_params
        params.permit(:password, :password_confirmation)
      end
    end
  end
end
