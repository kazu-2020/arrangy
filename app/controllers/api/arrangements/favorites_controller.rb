module Api
  module Arrangements
    class FavoritesController < ApplicationController
      def index
        pagy, arrangements = pagy(
          current_user.liking_arrangements.preload(:user, :after_arrangement_photo,
                                                   :before_arrangement_photo),
          items: 20
        )
        options = {
          include: %i[user after_arrangement_photo before_arrangement_photo],
          fields: {
            arrangement: %i[title created_at rating likes_count comments_count user after_arrangement_photo
                            before_arrangement_photo],
            user: %i[nickname avatar_url],
            after_arrangement_photo: %i[url],
            before_arrangement_photo: %i[url]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        json_string = ArrangementSerializer.new(arrangements, options)
        render json: json_string
      end
    end
  end
end
