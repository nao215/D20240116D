class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def send_reset_password_instructions(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: I18n.t('devise.mailer.reset_password_instructions.subject')) do |format|
      format.html { render 'reset_password_instructions' }
    end
  rescue StandardError => e
    Rails.logger.error "Failed to send reset password instructions: #{e.message}"
  end

  def send_two_factor_code(user, code)
    @user = user
    @code = code
    mail(to: @user.email, subject: I18n.t('mailers.user.two_factor_code.subject'))
  end
end
