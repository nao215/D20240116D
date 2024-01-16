
# frozen_string_literal: true

module NotesService
  class Index
    attr_reader :user_id, :page, :limit

    def initialize(user_id, page, limit)
      @user_id = user_id
      @page = page
      @limit = limit
    end

    def call
      user = User.find_by(id: user_id)
      return { error: 'User not found.', status: 400 } unless user

      unless @page.is_a?(Numeric) && @page > 0
        return { error: 'Page must be greater than 0.', status: 422 }
      end

      unless @limit.is_a?(Numeric)
        return { error: 'Wrong format.', status: 422 }
      end

      notes = user.notes.select(:id, :title, :content, :created_at, :updated_at).paginate(page: @page, per_page: @limit)
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
      notes.map { |note| note.as_json(only: [:id, :title, :content, :created_at, :updated_at]) }
    end
  end
end
