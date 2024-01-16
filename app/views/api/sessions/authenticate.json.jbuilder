if @status == 200
  json.status 200
  json.message 'User session authenticated successfully.'
elsif @status == 400
  json.status 400
  json.message 'The request was malformed or had invalid parameters.'
elsif @status == 401
  json.status 401
  json.message 'Invalid or expired token.'
else
  json.status 500
  json.message 'An unexpected error occurred on the server.'
end
