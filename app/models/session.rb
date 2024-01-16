
class Session < ApplicationRecord
  belongs_to :user

  # validations

  # end for validations

  class << self
    def invalidate_user_sessions(user_id)
      where(user_id: user_id).delete_all
    end
  end
end
