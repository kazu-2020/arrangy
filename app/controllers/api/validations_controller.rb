module Api
  class ValidationsController < ApplicationController
    def unique
      result = User.where('NOT(id = ?) and (nickname = ? or email= ?)', params[:id], params[:nickname], params[:email]).exists? ? 'exist' : 'unique'
      render json: { meta: result }
    end
  end
end
