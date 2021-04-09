class Api::OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    # binding.pry
    # login_at(params[:provider])
    login_at(:google)
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path
      rescue
        redirect_to root_path
      end
    end
  end
end
