module Api

  class SessionsController < ApplicationController
    def create
      user = login(params[:email], params[:password])
      if user
        json_string = UserSerializer.new(user).serializable_hash.to_json
        render json: json_string
      else
        head :unauthorized
      end
    end

  end
end
