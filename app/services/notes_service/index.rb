
# frozen_string_literal: true

require_relative '../session_service/validate_session'
module NotesService
  class Index
    attr_reader :user_id, :page, :limit

    def initialize(user_id, page, limit)
      @user_id = user_id
      @page = page
      @limit = limit
    end

    def call
      session = Session.find_by(user_id: user_id)
      unless SessionService::ValidateSession.new(session).call
        return { error: 'User not authorized.', status: 401 }
      end

      # Continue with the existing checks and note retrieval
      user = User.find_by(id: user_id)
      return { error: 'User not found.', status: 400 } unless user

      unless @page.to_i > 0
        return { error: 'Page must be greater than 0.', status: 422 }
      end

      unless @limit.is_a?(Numeric)
        return { error: 'Wrong format.', status: 422 }
      end

      notes = user.notes.select(:id, :title, :content, :created_at).paginate(page: @page.to_i, per_page: @limit.to_i)
      total_pages = (user.notes.count / @limit.to_f).ceil

      {
        notes: format_notes(notes),
        total_pages: total_pages,
        limit: @limit,
        page: @page
      }
    rescue StandardError => e
      Rails.logger.error "Error retrieving user notes: #{e.message}"
      # This is a placeholder for error handling
      { error: e.message, status: 500 }
    end

    private

    def format_notes(notes) # Include created_at in the formatted notes
      notes.map do |note|
        {
          id: note.id,
          title: note.title,
          content: note.content,
          user_id: note.user_id,
          created_at: note.created_at
        }
      end
    end
  end
end
