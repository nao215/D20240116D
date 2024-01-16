class SendTwoFactorCodeJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 3

  def perform(user_id, code)
    begin
      TwoFactorAuthenticationService.send_code_to_user(user_id, code)
    rescue StandardError => e
      Rails.logger.error "Failed to send two-factor code: #{e.message}"
      # Optionally, you can include logic to retry the job or handle the failure
      # For example, you might want to retry with a delay:
      # self.class.set(wait: 10.seconds).perform_later(user_id, code) if retries_left > 0
    end
  end

  private

end
