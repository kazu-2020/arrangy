module Api
  class UsersController < ApplicationController
    skip_before_action :require_login

    def create
      user = User.new(user_params)
      if user.save
        auto_login(user)
        json_string = UserSerializer.new(user).serializable_hash
        render json: json_string
      else
        head 400
      end
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
