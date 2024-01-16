
class NoteService::Delete < BaseService
  def initialize(note_id, user_id, token)
    @token = token
    @note_id = note_id
    @user_id = user_id
  end

  def call
    session_validation = ValidateSession.new(@token).call
    raise session_validation[:error_message] unless session_validation[:authenticated]

    user = User.find_by(id: session_validation[:user_id])
    raise 'User not found or not authenticated' unless user && user.id == @user_id

    note = user.notes.find_by(id: @note_id)
    raise 'Note not found or not associated with the user' unless note

    if note.destroy
      { message: 'Note has been successfully deleted.' }
    else
      raise 'Error deleting the note'
    end
  rescue => e
    log_error(e)
    { error: e.message }
  end

  private

  def log_error(error)
    # Log the error (implementation depends on the logging strategy of the project)
    Rails.logger.error(error)
  end
end
