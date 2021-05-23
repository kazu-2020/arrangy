module Api
  module Arrangements
    class FavoritesController < ApplicationController
      def index
        pagy, arrangements = pagy(current_user.liking_arrangements.preload(:user), items: 20)
        options = {
          include: %i[user],
          fields: {
            arrangement: %i[title images created_at likes_count comments_count user],
            user: %i[nickname avatar_url]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        json_string = ArrangementSerializer.new(arrangements, options)
        render json: json_string
      end
    end
  end
end
