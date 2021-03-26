module Api
  class SessionsController < ApplicationController
    skip_before_action :require_login, only: %i[create]

    def create
      user = login(params[:email], params[:password])
      raise ActiveRecord::RecordNotFound unless user

      json_string = UserSerializer.new(user).serializable_hash
      render json: json_string
    end

    def destroy
      logout
      head :no_content
    end
  end
end
