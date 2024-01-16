# frozen_string_literal: true

require 'securerandom'

module NoteService
  class Create
    attr_reader :user_id, :title, :content, :id

    def initialize(user_id:, title: nil, content:, id: nil)
      @user_id = user_id
      @title = title
      @content = content.presence || ''
      @id = id
    end

    def call
      user = User.find_by(id: @user_id)
      return { error_message: 'User not found' } if user.nil?

      # The new code checks for presence of content, which is a more robust check
      # than the existing code's check for blankness of both title and content.
      return { error_message: 'Title and content cannot be blank' } if @title.blank? || @content.blank?

      if @id
        note = user.notes.find_by(id: @id)
        return { error_message: 'Note not found' } if note.nil?
        note.update!(title: @title, content: @content, updated_at: Time.current)
      else
        # The new code checks for blankness of title before creating a new note,
        # which is consistent with the existing code.
        return { error_message: 'Title cannot be blank' } if @title.blank?
        note = user.notes.new(
          title: @title,
          content: @content,
          created_at: Time.current,
          updated_at: Time.current
        )
        # The new code sets a UUID for the note ID, which is not present in the existing code.
        note.id = SecureRandom.uuid
        if note.save
          return note_response(note)
        else
          return { error_message: note.errors.full_messages.join(', ') }
        end
      end

      note_response(note)
    rescue ActiveRecord::RecordNotFound => e
      { error_message: e.message }
    rescue ActiveRecord::RecordInvalid => e
      { error_message: e.message }
    end

    private

    def note_response(note)
      {
        id: note.id,
        title: note.title,
        content: note.content,
        created_at: note.created_at.iso8601,
        updated_at: note.updated_at.iso8601
      }
    end
  end
end
