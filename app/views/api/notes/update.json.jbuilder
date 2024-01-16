json.status 200
json.note do
  json.extract! @note, :id, :title, :content, :user_id
  json.id @note.id
  json.title @note.title
  json.content @note.content
  json.user_id @note.user_id
  json.updated_at @note.updated_at.iso8601
  json.created_at @note.created_at.iso8601
end
