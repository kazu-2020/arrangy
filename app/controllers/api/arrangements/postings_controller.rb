module Api
  module Arrangements
    class PostingsController < ApplicationController
      def index
        pagy, arrangements = pagy(current_user.arrangements.sorted_by_new.preload(:parameter), items: 20)
        options = {
          include: %i[parameter after_arrangement_photo],
          fields: {
            arrangement: %i[title context created_at likes_count comments_count parameter after_arrangement_photo],
            parameter: %i[taste spiciness sweetness satisfaction],
            after_arrangement_photo: %i[url]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        json_string = ArrangementSerializer.new(arrangements, options)
        render json: json_string
      end
    end
  end
end
