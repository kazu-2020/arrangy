module Api
  class ProfilesController < ApplicationController
    def update
      current_user.update!(user_params)
      json_string = UserSerializer.new(current_user).serializable_hash
      render json: json_string
    end

    def password
      current_user.password_confirmation = params[:password_confirmation]
      current_user.change_password!(params[:password])
      head 200
    end

    private

    def user_params
      params[:user][:avatar] = create_uploadedfile(params[:user][:avatar])
      params.require(:user).permit(:nickname, :email, :avatar)
    end
  end
end
