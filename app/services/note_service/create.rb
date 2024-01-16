# frozen_string_literal: true

module NoteService
  class Create
    attr_reader :user_id, :title, :content, :id

    def initialize(user_id:, title: nil, content:, id: nil)
      @user_id = user_id
      @title = title
      @content = content
      @id = id
    end

    def call
      user = User.find_by(id: @user_id)
      return { error_message: 'User not found' } if user.nil?
      return { error_message: 'Title and content cannot be blank' } if @title.blank? && @content.blank?

      if @id
        note = user.notes.find_by(id: @id)
        return { error_message: 'Note not found' } if note.nil?
        note.update!(title: @title, content: @content, updated_at: Time.current)
      else
        return { error_message: 'Title cannot be blank' } if @title.blank?
        note = user.notes.create!(
          title: @title,
          content: @content,
          created_at: Time.current,
          updated_at: Time.current
        )
      end

      {
        id: note.id,
        title: note.title,
        content: note.content,
        created_at: note.created_at.iso8601,
        updated_at: note.updated_at.iso8601
      }
    rescue ActiveRecord::RecordNotFound => e
      { error_message: e.message }
    rescue ActiveRecord::RecordInvalid => e
      { error_message: e.message }
    end
  end
end
