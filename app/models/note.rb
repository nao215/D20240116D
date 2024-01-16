
class Note < ApplicationRecord
  belongs_to :user

  # validations
  validates_presence_of :title, message: I18n.t('activerecord.errors.messages.blank')
  validates_presence_of :content, message: I18n.t('activerecord.errors.messages.blank')
  # end for validations

  class << self
  end
end
