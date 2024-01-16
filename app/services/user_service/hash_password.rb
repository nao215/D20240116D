module UserService
  class HashPassword
    require 'bcrypt'

    def self.hash_password(password_hash)
      hashed_password = BCrypt::Password.create(password_hash)
      hashed_password.to_s
    end
  end
end
