module Api
  class ArrangementsController < ApplicationController
    before_action :require_login, only: %i[create]

    def index
      pagy, arrangements = pagy(Arrangement.preload(:user), items: 20)
      options = { include: [:user], meta: { pagy: pagy_metadata(pagy) } }
      json_string = ArrangementSerializer.new(arrangements, options).serializable_hash
      render json: json_string
    end

    def create
      arrangement = current_user.arrangements.build(set_arrangement)
      if arrangement.save
        head 200
      else
        render json: arrangement.errors.full_messages, status: :bad_request
      end
    end

    private

    def set_arrangement
      params.dig(:data, :attributes, :images).map! { |image| create_uploadedfile(image) }
      params[:data].require(:attributes).permit(:title, :context, { images: [] })
    end
  end
end
