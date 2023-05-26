class CastMember < ApplicationRecord
  belongs_to :movie

  validates :name, presence: true
end
