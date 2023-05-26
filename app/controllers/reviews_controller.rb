class ReviewsController < ApplicationController
    before_action :set_movie, only: [:create, :destroy]

    def create
        @review = @movie.reviews.create(review_params)
        redirect_to movie_path(@movie)
    end

    def destroy
        @review = @movie.reviews.find(params[:id])
        @review.destroy
        redirect_to movie_path(@movie), status: :see_other
    end

    def import
        file = params[:file]
        DataLoaderService.new.load_reviews(file)
        redirect_to movies_path, notice: "Reviews imported!"
    end

    private
        def set_movie
            @movie = Movie.find(params[:movie_id])
        end

        def review_params
            params.require(:review).permit(:movie_id, :user_id, :comments, :rating, :movie_name)
        end
end
