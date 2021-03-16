module Api
  class SessionsController < ApplicationController
    before_action :require_login, only: :destroy

    def create
      user = login(params[:data][:email], params[:data][:password])
      if user
        json_string = UserSerializer.new(user).serializable_hash.to_json
        render json: json_string
      else
        head :unauthorized
      end
    end

    def destroy
      logout
      head 200
    end
  end
end
