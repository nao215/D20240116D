class Session < ApplicationRecord
  belongs_to :user

  # validations

  # end for validations

  class << self
    def generate_token
      loop do
        token = SecureRandom.hex(10)
        break token unless Session.exists?(token: token)
      end
    end
  end

  def create_session_for_user(user)
    self.user = user
    self.token = self.class.generate_token
    save
    token
  end
end
