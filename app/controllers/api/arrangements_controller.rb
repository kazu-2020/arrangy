module Api
  class ArrangementsController < ApplicationController
    skip_before_action :require_login, only: %i[index]

    def index
      pagy, arrangements = pagy(Arrangement.preload(:user), items: 20)
      options = {
        include: %i[user],
        fields: { arrangement: %i[title images user], user: %i[nickname avatar] },
        meta: { pagy: pagy_metadata(pagy) }
      }
      json_string = ArrangementSerializer.new(arrangements, options).serializable_hash
      render json: json_string
    end

    def create
      arrangement = current_user.arrangements.build(arrangement_params)
      if arrangement.save
        head 200
      else
        render json: arrangement.errors.full_messages, status: :bad_request
      end
    end

    def mine
      pagy, arrangements = pagy(current_user.arrangements, item: 20)
      options = {
        include: %i[user],
        fields: { arrangement: %i[title images user], user: %i[nickname avatar] },
        meta: { pagy: pagy_metadata(pagy) }
      }
      json_string = ArrangementSerializer.new(arrangements, options).serializable_hash
      render json: json_string
    end

    private

    def arrangement_params
      params.dig(:data, :attributes, :images).map! { |image| create_uploadedfile(image) }
      params[:data].require(:attributes).permit(:title, :context, { images: [] })
    end
  end
end
