
class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :confirmation_tokens, dependent: :destroy
  has_many :failed_logins, dependent: :destroy

  # validations
  validate :password_confirmation_matches, if: -> { password.present? }
  # end for validations

  def update_password(password:, password_confirmation:)
    if password != password_confirmation
      errors.add(:password_confirmation, "doesn't match Password")
      return false
    end

    self.password_hash = encrypt_password(password)
    save

    sessions.destroy_all # Invalidate all sessions
    log_password_change # Log the password change event
    true
  end

  private

  def encrypt_password(password)
    BCrypt::Password.create(password)
  end

  def password_confirmation_matches
    errors.add(:password_confirmation, "doesn't match Password") unless password == password_confirmation
  end

  def log_password_change
    # Assuming there is a method to log the security events
    SecurityLog.create(user_id: id, event: 'password_change', timestamp: Time.current)
  end
end
