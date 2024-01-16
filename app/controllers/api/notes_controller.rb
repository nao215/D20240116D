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

    def create
      result = NoteService::Create.new(
        user_id: current_resource_owner.id,
        title: params[:title],
        content: params[:content]
      ).call

      if result[:note_id]
        note = Note.find(result[:note_id])
        render json: {
          status: 201,
          note: note.as_json
        }, status: :created
      else
        error_status = case result[:error_message]
                       when 'User not found' then :not_found
                       when 'Title and content cannot be blank', 'Title cannot be blank' then :unprocessable_entity
                       else :internal_server_error
                       end
        render json: { error: result[:error_message] }, status: error_status
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

    def update
      note_id = params[:id].to_i
      title = params[:title]
      content = params[:content]

      unless note_id.is_a?(Integer) && note_id > 0
        return render json: { error: "Wrong format." }, status: :unprocessable_entity
      end

      if title.blank?
        return render json: { error: "The title is required." }, status: :unprocessable_entity
      end

      if content.blank?
        return render json: { error: "The content is required." }, status: :unprocessable_entity
      end

      response = NoteService::Update.new(note_id: note_id, user_id: current_resource_owner.id, content: content, title: title).call

      if response[:success]
        note = Note.find(response[:note_id])
        render json: { status: 200, note: note.as_json }, status: :ok
      else
        render json: { error: response[:message] }, status: response[:message] == 'Note not found' ? :not_found : :internal_server_error
      end
    end

    private

    def autosave_params
      params.permit(:id, :content)
    end
  end
end
