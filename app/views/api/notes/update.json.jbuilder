json.status 200
json.note do
  json.extract! @note, :id, :title, :content, :user_id, :updated_at, :created_at
  json.updated_at @note.updated_at.iso8601
  json.created_at @note.created_at.iso8601
end
