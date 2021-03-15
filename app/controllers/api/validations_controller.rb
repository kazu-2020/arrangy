module Api
  class ValidationsController < ApplicationController
    def unique
      result = User.where.not(id: params[:id]).where('nickname = ? or email= ?', params[:nickname], params[:email]).exists? ? 'exist' : 'unique'
      render json: { meta: result }
    end
  end
end
