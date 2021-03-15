module Api
  class ValidationsController < ApplicationController
    def unique
      users = User.where.not(id: params[:id]).where('nickname = ? or email= ?', params[:nickname], params[:email])
      result = users.exists? ? 'exist' : 'unique'
      render json: { meta: result }
    end
  end
end
