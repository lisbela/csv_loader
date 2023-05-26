class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :validate_movie, only: [:show, :edit]

  def index
    @movies = Movie.search(params[:search])
  end

  def show
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save 
      redirect_to @movie 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy

    redirect_to movies_path, status: :see_other
  end

  def import
    file = params[:file]
    DataLoaderService.new.load_movies(file)
    redirect_to movies_path, notice: "Movies imported!"
  end

  private
    def set_movie
      @movie = Movie.find_by(id: params[:id])
    end

    def movie_params
      return params.require(:movie).permit(:title, :description, :year, :director, :search)
    end

    def validate_movie
      redirect_to movies_path if @movie.nil?
    end
end
