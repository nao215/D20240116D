class Api::NotesController < ApplicationController
  before_action :doorkeeper_authorize!

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
end
