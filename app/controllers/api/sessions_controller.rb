module Api
  class SessionsController < Api::BaseController
    def authenticate
      token = params.require(:token)
      result = SessionService::ValidateSession.new(token).call

      if result[:authenticated]
        render json: { status: 200, message: 'User session authenticated successfully.' }, status: :ok
      else
        render_error(result[:error_message])
      end
    end

    private

    def render_error(message)
      case message
      when 'Session not found.', 'Token is invalid.'
        render json: { error: message }, status: :unauthorized
      when 'Session has expired.'
        render json: { error: message }, status: :forbidden
      else
        render json: { error: message }, status: :internal_server_error
      end
    end
  end
end
