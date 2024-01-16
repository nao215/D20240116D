module NoteService
  class Show < BaseService
    attr_reader :note_id

    def initialize(note_id)
      @note_id = note_id
    end

    def execute
      note = Note.find_by(id: note_id)
      raise ActiveRecord::RecordNotFound, "Note not found" unless note

      {
        title: note.title,
        content: note.content,
        updated_at: note.updated_at
      }
    end
  end
end
