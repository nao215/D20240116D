
class ConfirmationToken < ApplicationRecord
  belongs_to :user

  # validations

  # scope for valid tokens
  scope :valid, -> { where(used: false).where('expires_at > ?', Time.current) }

  # end for validations

  class << self
  end
end
