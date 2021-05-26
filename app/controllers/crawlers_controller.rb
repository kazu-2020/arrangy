class CrawlersController < ApplicationController
  skip_before_action :require_login
  before_action :set_arrangement, only: :show

  def show
    @after_arrangement_photo = @arrangement.after_arrangement_photo
  end

  private

  def set_arrangement
    @arrangement = Arrangement.find(decode_id(params[:id]))
  rescue StandardError => e
    render_404(e)
  end
end
