module Api
  module Validation
    class UniquenessController < ApplicationController
      skip_before_action :require_login

      def show
        users = User.where.not(id: params[:id])
                    .where('nickname = ? or email= ?', params[:nickname], params[:email]&.downcase)
        result = users.exists? ? 'exist' : 'unique'
        render json: { meta: result }
      end
    end
  end
end
