# frozen_string_literal: true

module NoteService
  class Update < BaseService
    attr_reader :note_id, :user_id, :content

    def initialize(note_id: nil, user_id:, content:)
      @note_id = note_id
      @user_id = user_id
      @content = content
    end

    def call
      user = User.find_by(id: user_id)
      return { success: false, message: 'User not found' } unless user

      note = note_id.present? ? user.notes.find_by(id: note_id) : nil

      if note
        if note.update(content: content, updated_at: Time.current)
          { success: true, message: 'Note updated successfully', note_id: note.id }
        else
          { success: false, message: 'Note update failed' }
        end
      else
        note = user.notes.create!(content: content, created_at: Time.current, updated_at: Time.current)
        { success: true, message: 'Note created successfully', note_id: note.id }
      end
    rescue ActiveRecord::RecordNotFound => e
      { success: false, message: e.message }
    rescue ActiveRecord::RecordInvalid => e
      { success: false, message: e.record.errors.full_messages.join(', ') }
    end
  end
end
