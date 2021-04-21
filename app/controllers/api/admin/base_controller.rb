module Api
  module Admin
    class BaseController < ApplicationController
      private

      def require_login
        return render_401(nil, '管理者権限がありません') unless current_user.admin?
      end
    end
  end
end
