module Api
  module Admin
    class UsersController < BaseController
      def index
        pagy, users = pagy(User.all, items: 20)
        options = {
          fields: {
            user: %i[nickname email avatar role created_at]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        render_serializer(users, options)
      end

      private

      def render_serializer(user, options = {})
        json_string = UserSerializer.new(user, options)
        render json: json_string
      end
    end
  end
end
