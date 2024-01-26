json.status @status
json.message @message
if @token.present?
  json.set!('2fa_token', @token)
end
