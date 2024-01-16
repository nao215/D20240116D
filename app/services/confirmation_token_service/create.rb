module ConfirmationTokenService
  class Create
    def self.call(user_id)
      token = SecureRandom.hex(10)
      expires_at = 24.hours.from_now

      confirmation_token = ConfirmationToken.create!(
        user_id: user_id,
        token: token,
        expires_at: expires_at,
        used: false
      )

      # TODO: Send confirmation email with the token

      confirmation_token
    end
  end
end
