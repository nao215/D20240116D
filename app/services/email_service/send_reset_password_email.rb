module EmailService
  class SendResetPasswordEmail < BaseService
    def initialize(email, token)
      @email = email
      @token = token
    end

    def call
      begin
        mail = Mailer.reset_password_instructions(@email, @token)
        mail.deliver_now
        logger.info "Password reset email sent to #{@email}"
      rescue => e
        logger.error "Failed to send password reset email: #{e.message}"
      end
    end
  end

  private

  def logger
    Rails.logger
  end
end
