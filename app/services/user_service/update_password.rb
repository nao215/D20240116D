class UpdatePasswordService < BaseService
  def call(user_id:, password:, password_confirmation:)
    raise StandardError.new('Passwords do not match') unless password == password_confirmation

    user = User.find(user_id)
    raise ActiveRecord::RecordNotFound.new('User not found') unless user

    encrypted_password = BCrypt::Password.create(password)
    user.update!(password_hash: encrypted_password)

    Session.where(user_id: user_id).destroy_all

    log_password_change(user_id)

    { success: true, message: 'Password has been updated successfully.' }
  rescue StandardError => e
    { success: false, message: e.message }
  end

  private

  def log_password_change(user_id)
    logger.info "Password change event for user_id: #{user_id} at #{Time.current}"
  end
end

# Note: BaseService is assumed to be present and contains common service functionality including logging.
# BCrypt is assumed to be part of the Gemfile and does not need to be explicitly required in a Rails project.
