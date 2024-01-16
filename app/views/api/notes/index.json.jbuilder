json.status 200
json.total_pages @total_pages
json.limit @limit
json.page @page

json.notes @notes, :id, :title, :content, :created_at, :updated_at
  json.extract! note, :id, :title, :content, :created_at, :updated_at
end
