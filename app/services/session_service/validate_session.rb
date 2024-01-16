class ValidateSession < BaseService
  def initialize(token)
    @token = token
  end

  def call
    validate_token # Ensure the token is present
    session = Session.find_by(token: @token)
    return { authenticated: false, error_message: 'Session not found.' } unless session

    if session.expires_at > Time.current
      { authenticated: true, user_id: session.user_id }
    else
      { authenticated: false, error_message: 'Session has expired.' }
    end
  rescue => e
    log_error(e)
    { authenticated: false, error_message: 'An error occurred during authentication.' }
  end

  private

  def validate_token
    raise ArgumentError, 'Token is invalid.' if @token.blank?
  end

  def log_error(error)
    # Assuming there's a logger method available within BaseService
    logger.error "Authentication error: #{error.message}"
  end
end
