module Api
  module Arrangements
    class PostingsController < ApplicationController
      def index
        pagy, arrangements = pagy(
          current_user.arrangements.sorted_by_new.preload(:after_arrangement_photo,
                                                          :before_arrangement_photo),
          items: 15
        )
        options = {
          include: %i[after_arrangement_photo before_arrangement_photo],
          fields: {
            arrangement: %i[title context rating arrange_level
                            created_at likes_count comments_count
                            after_arrangement_photo
                            before_arrangement_photo],
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
