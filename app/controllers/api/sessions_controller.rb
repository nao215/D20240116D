
module Api
  class SessionsController < Api::BaseController
    def authenticate
      token = params.require(:token)
      begin
        result = SessionService::ValidateSession.new(token).call
      rescue ArgumentError => e
        case e.message
        when 'Token is invalid.'
          render json: { error: "The token is required." }, status: :bad_request
          return
        end
      end

      if result[:authenticated]
        render json: { status: 200, message: 'User session authenticated successfully.' }, status: :ok
      else
        case result[:error_message]
        when 'Session not found.', 'Session has expired.'
          render json: { error: result[:error_message] }, status: :unauthorized
        else
          render json: { error: result[:error_message] }, status: :internal_server_error
        end
      end
    end
  end
end
