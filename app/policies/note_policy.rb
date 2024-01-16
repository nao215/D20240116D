class NotePolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super # Assuming ApplicationPolicy has an initialize method we should call
    @user = user
    @record = record
  end

  def index?
    user.id == record.user_id
  end

  def create?
    user.id == record.user_id
  end

  # The new update? method is more concise and uses a different style.
  # We'll keep the new one as it is functionally equivalent to the old one.
  def update?
    user.is_a?(User) && record.user_id == user.id
  end

  def destroy?
    user.id == record.user_id
  end
end

# Note: The ApplicationPolicy class is assumed to be present in the application
# and is supposed to provide a basic structure for policy classes.
# The user method is assumed to return the current authenticated user.
# The record is the instance of the model that we are authorizing actions upon.
