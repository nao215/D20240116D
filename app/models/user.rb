class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :confirmation_tokens, dependent: :destroy
  has_many :failed_logins, dependent: :destroy

  # validations

  # end for validations

  class << self
  end

  # Instance method to confirm user's email
  def confirm_email
    self.email_confirmed = true
    save
  end

end
