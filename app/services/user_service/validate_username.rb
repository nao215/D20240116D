module UserService
  class << self
    def validate_username(username)
      !User.exists?(username: username)
    end
  end
end

# Import User model from "app/models/user.rb" is not needed as Rails autoloads it.
