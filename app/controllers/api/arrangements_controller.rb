module Api
  class ArrangementsController < ApplicationController
    before_action :require_login

    include Api::ArrangementBase64

    def index
      arrangements = Arrangement.all
      render json: arrangements
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
      params[:arrangement][:images].map! { |image| create_uploadedfile(image) }
      params.require(:arrangement).permit(:title, :context, { images: [] })
    end
  end
end
