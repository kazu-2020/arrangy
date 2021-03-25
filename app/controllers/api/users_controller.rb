module Api
  class UsersController < ApplicationController
    wrap_parameters :user, include: %i[nickname email password password_confirmation]

    skip_before_action :require_login

    def create
      user = User.new(user_params)
      user.save!
      auto_login(user)
      json_string = UserSerializer.new(user).serializable_hash
      render json: json_string
    end

    def me
      json_string = UserSerializer.new(current_user).serializable_hash
      render json: json_string
    end

    private

    def user_params
      params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
    end
  end
end
