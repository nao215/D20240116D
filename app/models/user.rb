class User < ApplicationRecord
  has_many :notes, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
