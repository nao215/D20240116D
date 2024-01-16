module NoteService
  class Create < BaseService
    attr_reader :user_id, :title, :content

    def initialize(user_id, title, content)
      @user_id = user_id
      @title = title
      @content = content
    end

    def call
      return { error_message: 'User not found' } unless User.exists?(user_id)
      return { error_message: 'Title and content cannot be blank' } if title.blank? || content.blank?

      timestamp = Time.current
      note = Note.create!(
        user_id: user_id,
        title: title,
        content: content,
        created_at: timestamp,
        updated_at: timestamp
      )
      { note_id: note.id }
    rescue ActiveRecord::RecordInvalid => e
      { error_message: e.message }
    end
  end
end
