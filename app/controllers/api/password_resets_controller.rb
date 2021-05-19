module Api
  class PasswordResetsController < ApplicationController
    skip_before_action :require_login

    def create
      user = User.find_by(email: params[:email])

      user&.generate_reset_password_token!
      UserMailer.reset_password_email(user).deliver_now
      head :ok
    end

    def update
      user = User.load_from_reset_password_token(params[:token])
      return render_400 unless user

      password_form = UpdatePasswordForm.new(user: user, params: user_params)
      password_form.save!
      head :no_content
    end

    private

    def user_params
      params.require(:password_reset).permit(:password, :password_confirmation)
    end
  end
end
