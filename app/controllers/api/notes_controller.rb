class Api::NotesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:update, :confirm, :autosave]

  def update
    note_id = params[:id]
    title = params[:title]
    content = params[:content]

    return render json: { error: "Note not found." }, status: :not_found unless Note.exists?(note_id)
    return render json: { error: "Wrong format." }, status: :unprocessable_entity unless note_id.match?(/^\d+$/)
    return render json: { error: "The title is required." }, status: :bad_request if title.blank?
    return render json: { error: "The content is required." }, status: :bad_request if content.blank?

    result = NoteService::Update.new(note_id: note_id, user_id: current_resource_owner.id, title: title, content: content).call

    if result[:success]
      note = Note.find(note_id)
      render json: {
        status: 200,
        note: {
          id: note.id,
          title: note.title,
          content: note.content,
          updated_at: note.updated_at.iso8601
        }
      }, status: :ok
    else
      render json: { error: result[:message] }, status: :internal_server_error
    end
  end

  def confirm
    if params[:id].match?(/\A\d+\z/)
      note_id = params[:id].to_i
      note = Note.find_by(id: note_id)

      if note
        render json: {
          status: 200,
          message: "Note save confirmed.",
          note: {
            id: note.id,
            title: note.title,
            content: note.content,
            created_at: note.created_at.iso8601,
            updated_at: note.updated_at.iso8601
          }
        }, status: :ok
      else
        base_render_record_not_found
      end
    else
      render json: { message: "Wrong format." }, status: :bad_request
    end
  end

  def autosave
    note_id = autosave_params[:id]
    content = autosave_params[:content]

    unless note_id.is_a?(Integer)
      return render json: { message: "Wrong format." }, status: :unprocessable_entity
    end

    if content.blank?
      return render json: { message: "The content is required." }, status: :bad_request
    end

    response = NoteService::Update.new(note_id: note_id, user_id: current_resource_owner.id, content: content).call

    if response[:success]
      render json: { status: 200, message: "Note auto-saved successfully." }, status: :ok
    else
      case response[:message]
      when 'Note not found'
        render json: { message: response[:message] }, status: :unprocessable_entity
      else
        render json: { message: response[:message] }, status: :internal_server_error
      end
    end
  end

  private

  def autosave_params
    params.permit(:id, :content)
  end

  def base_render_record_not_found
    render json: { message: "Record not found." }, status: :not_found
  end
end
