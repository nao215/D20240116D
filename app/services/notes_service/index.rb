# frozen_string_literal: true

module NotesService
  class Index
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def call
      user = User.find_by(id: user_id)
      return [] unless user # Assuming user must be logged in to have a session

      notes = user.notes.select(:id, :title, :content, :updated_at)
      format_notes(notes)
    rescue StandardError => e
      # Handle exceptions and provide error messages
      # This is a placeholder for error handling
      []
    end

    private

    def format_notes(notes)
      notes.as_json(only: [:id, :title, :content, :updated_at])
    end
  end
end
