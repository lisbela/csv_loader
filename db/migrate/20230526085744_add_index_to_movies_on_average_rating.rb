class AddIndexToMoviesOnAverageRating < ActiveRecord::Migration[7.0]
  def change
    add_index :movies, :average_rating
  end
end