module Api
  class AuthUsersController < ApplicationController
    skip_before_action :require_login, only: %i[create show]

    def create
      user = login(params[:email], params[:password])
      raise ActiveRecord::RecordNotFound unless user

      options = { fields: { user: %i[nickname email avatar] } }
      render_serializer(current_user, options)
    end

    def show
      options = { fields: { user: %i[nickname email avatar] } }
      render_serializer(current_user, options)
    end

    def update
      current_user.update!(user_params)
      options = { fields: { user: %i[nickname email avatar] } }
      render_serializer(current_user, options)
    end

    def destroy
      logout
      head :no_content
    end

    private

    def user_params
      params[:user][:avatar] = create_uploadedfile(params[:user][:avatar])
      params.require(:user).permit(:nickname, :email, :avatar)
    end

    def render_serializer(user, options = {})
        json_string = UserSerializer.new(user, options)
        render json: json_string
    end
  end
end
