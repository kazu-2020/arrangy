module Api
  class UsersController < ApplicationController
    def create
      user = User.new(set_user)
      if user.save
        head 200
      else
        head 400
      end
    end

    def me
      if current_user
        json_string = UserSerializer.new(current_user).serializable_hash.to_json
        render json: json_string
      else
        render json: nil
      end
    end

    private

    def set_user
      params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
    end
  end
end
