json.status @status

if @error_message.present?
  json.message @error_message
else
  json.message "Note auto-saved successfully."
