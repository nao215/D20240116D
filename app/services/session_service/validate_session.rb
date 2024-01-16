
class ValidateSession < BaseService
  def initialize(token)
    @token = token
  end

  def call
    validate_token_presence # Ensure the token is present
    session = Session.find_by(token: @token)
    raise ArgumentError, 'Invalid or expired token.' if session.nil? || session.expires_at <= Time.current

    { authenticated: true, user_id: session.user_id }
  rescue ArgumentError => e
    { authenticated: false, error_message: e.message }
  rescue => e
    log_error(e)
    { authenticated: false, error_message: 'An error occurred during authentication.' }
  end

  private

  def validate_token_presence
    raise ArgumentError, 'The token is required.' if @token.blank?
  end

  def log_error(error)
    # Assuming there's a logger method available within BaseService
    logger.error "Authentication error: #{error.message}"
  end
end
