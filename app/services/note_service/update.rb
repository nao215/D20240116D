
# frozen_string_literal: true

module NoteService
  class Update < BaseService
    attr_reader :note_id, :user_id, :title, :content

    def initialize(note_id: nil, user_id:, title:, content:)
      @note_id = note_id
      @user_id = user_id
      @title = title
      @content = content
    end

    def call
      return { success: false, message: 'Title and content cannot be blank' } if title.blank? || content.blank?

      user = User.find_by(id: user_id)
      return { success: false, message: 'User not found' } unless user

      note = note_id.present? ? user.notes.find_by(id: note_id) : nil
      return { success: false, message: 'Note not found' } unless note

      note.assign_attributes(title: title, content: content, updated_at: Time.current)
      if note.save
        {
          success: true,
          message: 'Note updated successfully',
          note: {
            id: note.id,
            title: note.title,
            content: note.content,
            created_at: note.created_at,
            updated_at: note.updated_at
          }
        }
      else
        { success: false, message: 'Note update failed', errors: note.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound => e
      { success: false, message: e.message }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, message: e.record.errors.full_messages.join(', ') }
    end
  end
end
