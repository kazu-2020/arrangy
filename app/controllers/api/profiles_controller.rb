module Api
  class ProfilesController < ApplicationController
    def update
      if current_user.update(user_params)
        json_string = UserSerializer.new(current_user).serializable_hash
        render json: json_string
      else
        head 400
      end
    end

    def password
      current_user.password_confirmation = params[:data][:password_confirmation]
      current_user.change_password(params[:data][:password]) ? head(200) : head(400)
    end

    private

    def user_params
      params[:data][:user][:avatar] = create_uploadedfile(params[:data][:user][:avatar])
      params[:data].require(:user).permit(:nickname, :email, :avatar)
    end
  end
end
