# frozen_string_literal: true

module Api
  class NotesController < Api::BaseController
    before_action :doorkeeper_authorize!

    def index
      user_id = params[:user_id]
      user = User.find_by(id: user_id)

      if user.nil?
        render json: { error: 'User not found.' }, status: :not_found
      else
        begin
          notes_service = NotesService::Index.new(user_id)
          notes = notes_service.call
          render json: { status: 200, notes: notes }, status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :internal_server_error
        end
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
  end
end
