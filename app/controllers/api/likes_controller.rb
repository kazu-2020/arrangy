module Api
  class LikesController < ApplicationController
    before_action :set_arrangement, only: %i[create destroy]

    def create
      current_user.like(@arrangement)
      head :ok
    end

    def destroy
      current_user.unlike(@arrangement)
      head :no_content
    end

    private

    def set_arrangement
      @arrangement = Arrangement.find(decode_id(params[:arrangement_id]))
    end
  end
end
