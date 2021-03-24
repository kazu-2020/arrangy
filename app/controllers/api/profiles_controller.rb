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
      current_user.password_confirmation = params[:password_confirmation]
      current_user.change_password(params[:password]) ? head(200) : head(400)
    end

    private

    def user_params
      params[:user][:avatar] = create_uploadedfile(params[:user][:avatar])
      params.require(:user).permit(:nickname, :email, :avatar)
    end
  end
end
