module Api
  module Admin
    class ArrangementsController < BaseController
      def index
        pagy, arrangements = pagy(Arrangement.preload(:user), items: 20)
        options = {
          include: %i[user],
          fields: {
            arrangement: %i[title images created_at likes_count comments_count user],
            user: %i[nickname]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        render_serializer(arrangements, options)
      end

      private

      def render_serializer(arrangement, options = {})
        json_string = ArrangementSerializer.new(arrangement, options)
        render json: json_string
      end
    end
  end
end
