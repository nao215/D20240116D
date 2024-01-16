# frozen_string_literal: true

module Api
  class NotesController < Api::BaseController
    before_action :doorkeeper_authorize!
    before_action :set_user, only: [:index]

    def index
      user_id = params[:user_id] || @user&.id
      user = User.find_by(id: user_id)

      if user.nil?
        render json: { error: 'User not found.' }, status: :not_found
      else
        begin
          # Updated to include pagination parameters if provided
          notes_service = NotesService::Index.new(user_id, params[:page], params[:limit])
          notes = notes_service.call
          render json: { status: 200, notes: notes }, status: :ok
        rescue StandardError => e
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end

    def create
      # Use current_resource_owner by default, fallback to params[:user_id] if not present
      user_id = current_resource_owner.id || params[:user_id]
      title = params[:title]
      content = params[:content]

      result = NoteService::Create.new(
        user_id: user_id,
        title: title,
        content: content
      ).call

      if result[:note_id] || result[:id]
        note_id = result[:note_id] || result[:id]
        note = Note.find(note_id)
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

    def destroy
      note_id = params[:id].to_i
      user_id = current_resource_owner.id || params[:user_id].to_i

      unless note_id.is_a?(Integer) && note_id > 0
        return render json: { error: "Wrong format." }, status: :unprocessable_entity
      end

      unless user_id.is_a?(Integer) && user_id > 0
        return render json: { error: "User ID must be an integer." }, status: :unprocessable_entity
      end

      result = NoteService::Delete.new(note_id, user_id).call

      if result[:message]
        render json: { status: 200, message: "Note successfully deleted." }, status: :ok
      elsif result[:error] == 'Note not found or not associated with the user'
        render json: { error: "Note not found." }, status: :unprocessable_entity
      else
        render json: { error: result[:error] }, status: :internal_server_error
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def set_user
      @user = current_resource_owner
      unless @user
        render json: { error: 'User must be logged in.' }, status: :unauthorized
      end
    end

    def autosave_params
      params.permit(:id, :content)
    end
  end
end
