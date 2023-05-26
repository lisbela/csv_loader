require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #index' do
    it 'assigns all movies to @movies' do
      movie1 = FactoryBot.create(:movie, title: 'Movie 1', description: 'Action', year: 2021, director: 'Director 1')
      movie2 = FactoryBot.create(:movie, title: 'Movie 2', description: 'Drama', year: 2022, director: 'Director 2')

      get :index
      expect(assigns(:movies)).to match_array([movie1, movie2])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested movie to @movie' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      get :show, params: { id: movie.id }
      expect(assigns(:movie)).to eq(movie)
    end

    it 'renders the show template' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      get :show, params: { id: movie.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested movie to @movie' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      get :edit, params: { id: movie.id }
      expect(assigns(:movie)).to eq(movie)
    end

    it 'renders the edit template' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      get :edit, params: { id: movie.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) { { movie: { title: 'Updated Movie' } } }
    let(:invalid_params) { { movie: { title: '' } } }

    it 'updates the requested movie with valid parameters' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      patch :update, params: { id: movie.id, movie: valid_params[:movie] }
      movie.reload
      expect(movie.title).to eq('Updated Movie')
    end

    it 'redirects to the movie with valid parameters' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      patch :update, params: { id: movie.id, movie: valid_params[:movie] }
      expect(response).to redirect_to(movie_path(movie))
    end

    it 'does not update the requested movie with invalid parameters' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      patch :update, params: { id: movie.id, movie: invalid_params[:movie] }
      movie.reload
      expect(movie.title).not_to eq('')
    end

    it 'renders the edit template with unprocessable_entity status with invalid parameters' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      patch :update, params: { id: movie.id, movie: invalid_params[:movie] }
      expect(response).to render_template(:edit)
      expect(response.status).to eq(422)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested movie' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      delete :destroy, params: { id: movie.id }
      expect(Movie.exists?(movie.id)).to be_falsey
    end

    it 'redirects to the movies list' do
      movie = Movie.create(title: 'Test Movie', description: 'Action', year: 2021, director: 'Director 1')
      delete :destroy, params: { id: movie.id }
      expect(response).to redirect_to(movies_path)
    end
  end
end
