module Api
  class ArrangementsController < ApplicationController
    skip_before_action :require_login, only: %i[index show]
    before_action :set_arrangement, only: %i[show update destroy]

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
        json_string = ArrangementSerializer.new(arrangement).serializable_hash
        render json: json_string
      else
        render json: arrangement.errors.full_messages, status: :bad_request
      end
    end

    def show
      options = {
        include: %i[user],
        fields: { arrangement: %i[title context images user], user: %i[nickname avatar] }
      }
      json_string = ArrangementSerializer.new(@arrangement, options).serializable_hash
      render json: json_string
    end

    def update
      render head 400 unless @arrangement.update(arrangement_params)
      options = {
        include: %i[user],
        fields: { arrangement: %i[title context images user], user: %i[nickname avatar] }
      }
      json_string = ArrangementSerializer.new(@arrangement, options).serializable_hash
      render json: json_string
    end

    def destroy
      @arrangement.destroy!
      head 200
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
      params[:arrangement][:images].map! { |image| create_uploadedfile(image) }
      params.require(:arrangement).permit(:title, :context, images: [])
    end

    def set_arrangement
      @arrangement = Arrangement.find(params[:id])
    end
  end
end
