module Api
  module Arrangements
    class PostingsController < ApplicationController
      def index
        pagy, arrangements = pagy(current_user.arrangements.sorted_by_new.preload(:parameter), items: 20)
        options = {
          include: %i[parameter],
          fields: {
            arrangement: %i[title images context created_at likes_count comments_count parameter],
            parameter: %i[taste spiciness sweetness satisfaction]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        json_string = ArrangementSerializer.new(arrangements, options)
        render json: json_string
      end
    end
  end
end
