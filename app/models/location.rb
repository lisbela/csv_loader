class Location < ApplicationRecord
  belongs_to :movie
  belongs_to :country

  validates :name, presence: true
end
