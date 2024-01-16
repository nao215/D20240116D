
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

      notes = user.notes.select(:id, :title, :content, :created_at, :updated_at)
      format_notes(notes)
    rescue StandardError => e
      Rails.logger.error "Error retrieving user notes: #{e.message}"
      # This is a placeholder for error handling
      []
    end

    private

    def format_notes(notes) # Include created_at in the formatted notes
      notes.as_json(only: [:id, :title, :content, :created_at, :updated_at])
    end
  end
end
