module UserService
  class VerifyTwoFactorAuthentication < BaseService
    def initialize(user_id, two_factor_code)
      @user_id = user_id
      @two_factor_code = two_factor_code
    end

    def call
      user = User.find_by(id: @user_id)
      return { status: 'error', message: 'User not found' } unless user

      session = user.sessions.where('expires_at > ?', Time.current).last
      return { status: 'error', message: 'Two-factor authentication code expired or not found' } unless session

      if session.token == @two_factor_code
        { status: 'success', message: 'Two-factor authentication verified' }
      else
        { status: 'error', message: 'Invalid two-factor authentication code' }
      end
    rescue ActiveRecord::RecordNotFound
      { status: 'error', message: 'User not found' }
    end

    private

    attr_reader :user_id, :two_factor_code
  end
end
