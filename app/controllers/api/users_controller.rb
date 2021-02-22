module Api
  class UsersController < ApplicationController
    def create
      user = User.new(set_user)
      if user.save
        head 200
      else
        head 400
      end
    end

    private

    def set_user
      params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
    end
  end
end
