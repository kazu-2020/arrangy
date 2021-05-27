module Api
  class UsersController < ApplicationController
    wrap_parameters :user, include: %i[nickname email password password_confirmation]

    skip_before_action :require_login, only: :create

    def create
      signup_form = SignupForm.new(user_params)
      signup_form.save!
      auto_login(signup_form.user)
      options = { fields: { user: %i[nickname email avatar_url] } }
      json_string = UserSerializer.new(signup_form.user, options)
      render json: json_string
    end

    def destroy
      user = User.find(params[:id])
      user.destroy!
      head :no_content
    end

    private

    def user_params
      params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
    end
  end
end
