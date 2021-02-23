module Api
  class ValidationsController < ApplicationController
    def unique
      result = User.where(nickname: params[:nickname]).or(User.where(email: params[:email])).exists? ? 'exist' : 'unique' # rubocop:disable Layout/LineLength
      render json: result
    end
  end
end
