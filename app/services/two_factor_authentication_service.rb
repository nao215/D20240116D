class TwoFactorAuthenticationService < BaseService
  EXPIRATION_TIME = 10.minutes

  def generate_code(user_id)
    SecureRandom.hex(3)
  end

  def send_code_to_user(user_id)
    user = User.find(user_id)
    code = generate_code(user_id)
    store_code_with_expiration(user_id, code)
    # Use ActionMailer or a third-party service to send the code
    # Example: UserMailer.two_factor_code(user, code).deliver_now
  end

  def store_code_with_expiration(user_id, code)
    Rails.cache.write("user_#{user_id}_two_factor_code", code, expires_in: EXPIRATION_TIME)
  end

  def verify_code(user_id, code)
    stored_code = Rails.cache.read("user_#{user_id}_two_factor_code")
    stored_code == code
  end

  def instructions_for_user(user_id)
    # Localized message or simple string with instructions
    I18n.t('two_factor_authentication.instructions')
  end

  private

  def send_sms(phone_number, code)
    # Use a service like Twilio to send SMS
    # Example: TwilioClient.new.send_sms(phone_number, "Your code is: #{code}")
  end

  def send_email(user, code)
    # Use ActionMailer to send email
    # Example: UserMailer.two_factor_code(user, code).deliver_now
  end
end
