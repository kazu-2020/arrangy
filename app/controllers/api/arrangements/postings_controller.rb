module Api
  module Arrangements
    class PostingsController < ApplicationController
      def index
        pagy, arrangements = pagy(current_user.arrangements.sorted_by_new, items: 20)
        options = {
          fields: {
            arrangement: %i[title images context created_at likes_count comments_count]
          },
          meta: { pagy: pagy_metadata(pagy) }
        }
        json_string = ArrangementSerializer.new(arrangements, options)
        render json: json_string
      end
    end
  end
end
