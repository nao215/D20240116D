module ConfirmationTokenService
  class Generate < BaseService
    def initialize(user_id)
      @user_id = user_id
    end

    def call
      token = SecureRandom.hex(10)
      expires_at = 2.hours.from_now

      ConfirmationToken.create!(
        user_id: @user_id,
        token: token,
        expires_at: expires_at
      )

      token
    rescue => e
      logger.error "Failed to generate confirmation token: #{e.message}"
      nil
    end
  end
end
