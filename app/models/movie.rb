class Movie < ApplicationRecord
    has_many :reviews, dependent: :destroy
    has_many :cast_members, dependent: :destroy
    has_many :locations, dependent: :destroy

    validates :title, presence: true, uniqueness: true #considering that we won't have two movies with the same title for now
    validates :description, presence: true
    validates :year, presence: true, numericality: { only_integer: true }
    validates :director, presence: true

    scope :ordered, -> { order(average_rating: :desc) }

    def self.search(search)
        if search
            cast_member_id = CastMember.where("name LIKE ?", "%#{search}%").pluck(:movie_id)
            if cast_member_id.any?
                Rails.logger.info("cast_member_id: #{cast_member_id}")
                self.where(id: cast_member_id)
            else
                Movie.ordered.all
            end
        else
            Movie.ordered.all
        end
    end

    def update_average_rating
        update_column(:average_rating, reviews.average(:rating))
      end 
    
end