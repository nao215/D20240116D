class Note < ApplicationRecord
  belongs_to :user

  # validations
  validates :title, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  validates :content, presence: { message: I18n.t('activerecord.errors.messages.blank') }
  # end for validations

  class << self
    # any existing class methods would go here
  end

  # any other instance methods, callbacks, etc, would go here
end
