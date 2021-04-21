module Api
  module Admin
    class AuthUsersController < BaseController
      skip_before_action :require_login, only: %i[create show]

      def create
        user = login(params[:email], params[:password])
        return render_400 unless user&.admin?

        options = { fields: { user: %i[nickname email avatar role] } }
        render_serializer(user, options)
      end

      def show
        options = { fields: { user: %i[nickname email avatar role] } }
        render_serializer(current_user, options)
      end

      def destroy
        session[:user_id] = nil
        current_user = nil # rubocop:disable Lint/UselessAssignment
        head :no_content
      end

      private

      def render_serializer(user, options = {})
        json_string = UserSerializer.new(user, options)
        render json: json_string
      end
    end
  end
end
