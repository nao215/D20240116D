class Note < ApplicationRecord
  belongs_to :user

  # validations
  validates :title, presence: { message: "The title is required." }, unless: Proc.new { |note| note.title.blank? && I18n.exists?('activerecord.errors.messages.blank') }
  validates :content, presence: { message: "The content is required." }, unless: Proc.new { |note| note.content.blank? && I18n.exists?('activerecord.errors.messages.blank') }

  validates_presence_of :title, message: I18n.t('activerecord.errors.messages.blank'), if: Proc.new { |note| note.title.blank? && I18n.exists?('activerecord.errors.messages.blank') }
  validates_presence_of :content, message: I18n.t('activerecord.errors.messages.blank'), if: Proc.new { |note| note.content.blank? && I18n.exists?('activerecord.errors.messages.blank') }
  # end for validations

  class << self
  end
end
