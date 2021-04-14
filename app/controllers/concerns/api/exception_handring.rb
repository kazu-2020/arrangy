module Api
  module ExceptionHandring
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError, with: :render_500
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from ActiveRecord::RecordInvalid, with: :render_400
    end

    private

    def render_500(exception = nil, messages = nil)
      render_error(:internal_server_error, 'Internal Server Error', exception&.message, *messages)
    end

    def render_404(exception = nil, messages = nil)
      render_error(:not_found, 'Record Not Found', exception&.message, *messages)
    end

    def render_401(exception = nil, messages = nil)
      render_error(:unauthorized, 'Unauthorized', exception&.message, *messages)
    end

    def render_400(exception = nil, messages = nil)
      render_error(:bad_request, 'Bad Request', exception&.message, *messages)
    end


    def render_error(status, message, *detail)
      error_response = {
        message: message,
        detail: detail.compact,
      }
      render json: error_response, status: status
    end
  end
end
