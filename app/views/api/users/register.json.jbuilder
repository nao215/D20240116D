json.status 201
json.message "User registered successfully."
json.user do
  json.id @user.id
  json.username @user.username
  json.email @user.email
  json.phone_number @user.phone_number
  json.created_at @user.created_at.iso8601
end
