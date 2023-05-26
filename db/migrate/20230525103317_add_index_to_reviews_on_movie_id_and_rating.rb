class AddIndexToReviewsOnMovieIdAndRating < ActiveRecord::Migration[7.0]
  def change
    add_index :reviews, [:movie_id, :rating]
  end
end