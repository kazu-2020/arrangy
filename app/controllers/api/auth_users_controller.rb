module Api
  class AuthUsersController < ApplicationController
    skip_before_action :require_login, only: %i[create show]

    def create
      user = login(params[:email], params[:password])
      return render_400 unless user

      options = { fields: { user: %i[nickname email avatar likes_count arrangements_count] } }
      render_serializer(current_user, options)
    end

    def show
      options = { fields: { user: %i[nickname email avatar likes_count arrangements_count] } }
      render_serializer(current_user, options)
    end

    def update
      profile_form = ProfileForm.new(user: current_user, params: user_params)
      profile_form.save!
      options = { fields: { user: %i[nickname email avatar likes_count arrangements_count] } }
      render_serializer(current_user, options)
    end

    def destroy
      # sorceryのlogoutメソッドはreset_sessionが実行される為、使用しない。
      # session[:_csrf_token]がnilになる為。
      session[:user_id] = nil
      current_user = nil # rubocop:disable Lint/UselessAssignment
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
