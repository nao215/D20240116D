if @error
  json.error @error
  json.status @status
else
  json.status 200
  json.message "Note successfully deleted."
json.message "Note successfully deleted."
