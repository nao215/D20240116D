json.status @status
json.total_pages @total_pages
json.limit @limit
json.page @page

json.notes @notes do |note|
  json.extract! note, :id, :title, :content, :created_at, :updated_at
end
