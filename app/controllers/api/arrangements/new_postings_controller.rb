module Api
  module Arrangements
    class NewPostingsController < ApplicationController
      skip_before_action :require_login, only: :index

      def index
        arrangements = Rails.cache.fetch('arrangements_new_postings', expires_in: 1.day) do
          Arrangement.order(created_at: :desc).limit(8).preload(:after_arrangement_photo,
                                                                :before_arrangement_photo)
        end

        options = {
          include: %i[after_arrangement_photo before_arrangement_photo],
          fields: {
            arrangement: %i[title arrange_level rating after_arrangement_photo before_arrangement_photo],
            after_arrangement_photo: :url,
            before_arrangement_photo: :url
          }
        }

        json_string = ArrangementSerializer.new(arrangements, options)
        render json: json_string
      end
    end
  end
end
