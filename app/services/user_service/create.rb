module UserService
  class Create
    def self.call(username:, password_hash:, email:, phone_number:)
      # Validate email format and uniqueness
      raise 'Invalid email format' unless email =~ URI::MailTo::EMAIL_REGEXP
      raise 'Email already taken' if User.exists?(email: email)

      # Validate username uniqueness
      raise 'Username already taken' if User.exists?(username: username)

      # Hash the password
      hashed_password = BCrypt::Password.create(password_hash)

      # Create the user record
      user = User.create!(
        username: username,
        password_hash: hashed_password,
        email: email,
        phone_number: phone_number,
        email_confirmed: false
      )

      # Generate a unique confirmation token
      token = SecureRandom.hex(10)
      expires_at = 2.days.from_now

      # Create a confirmation token record
      ConfirmationToken.create!(
        user_id: user.id,
        token: token,
        expires_at: expires_at,
        used: false
      )

      # Send a confirmation email
      UserMailer.confirmation_instructions(user, token).deliver_now

      # Return the response
      {
        user_id: user.id,
        email_confirmed: user.email_confirmed,
        message: 'User registered successfully. Confirmation email has been sent.'
      }
    rescue StandardError => e
      { error: e.message }
    end
  end
end
