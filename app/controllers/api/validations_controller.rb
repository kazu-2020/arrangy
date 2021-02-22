class Api::ValidationsController < ApplicationController
  def unique
    result = User.where(nickname: params[:nickname]).or(User.where(email: params[:email])).exists? ? "exist" : "unique"
    render json: result
  end
end
