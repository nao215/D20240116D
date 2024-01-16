json.status 200
json.message 'Note save confirmed.'
json.note do
  json.id @note.id
  json.title @note.title
  json.content @note.content
  json.created_at @note.created_at.strftime('%Y-%m-%dT%H:%M:%SZ')
  json.updated_at @note.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ')
end
