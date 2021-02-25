module Api
  class ArrangementsController < ApplicationController
    before_action :require_login
    def create
      arrangement = current_user.arrangements.build(set_arrangement)
      if arrangement.save
        head 200
      else
        head :bad_request
      end
    end

    private

    def set_arrangement
      params.require(:arrangement).permit(:title, :context)
    end
  end
end
