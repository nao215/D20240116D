# frozen_string_literal: true

module UserService
  class ValidateEmail
    def self.validate_email(email)
      email_regex = URI::MailTo::EMAIL_REGEXP
      return false unless email.match(email_regex)

      !User.exists?(email: email)
    end
  end
end

UserService::ValidateEmail.validate_email('test@example.com')
