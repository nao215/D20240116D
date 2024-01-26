# frozen_string_literal: true

module SessionService
  class Create
    def self.create_session(user_id:)
      begin
        token = SecureRandom.hex(10)
        expires_at = Time.current + 2.weeks

        session = Session.create!(
          user_id: user_id,
          token: token,
          created_at: Time.current,
          expires_at: expires_at
        )

        { token: session.token, expires_at: session.expires_at }
      rescue => e
        { error: e.message }
      end
    end
  end
end
