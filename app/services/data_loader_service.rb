class DataLoaderService
  require 'csv'

  def load_movies(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ',')

    csv.each do |row|
        movie_hash =  {}
        movie_hash[:title] = row['Movie']
        movie_hash[:description] = row['Description']
        movie_hash[:year] = row['Year']
        movie_hash[:director] = row['Director']
        movie_hash[:actor] = row['Actor']
        movie_hash[:location] = row['Filming location']
        movie_hash[:country] = row['Country']

        movie = Movie.find_by(title: movie_hash[:title])
        
        if movie
            Rails.logger.info("Movie already exists in database: #{movie_hash[:title]}")
        else
            Rails.logger.info("Loading movie: #{movie_hash[:title]}")
            movie = Movie.create(movie_hash)
        end

        Country.find_or_create_by!(name: movie_hash[:country])
        validate_cast(movie_hash, movie)
        validate_location(movie_hash, movie)
    end
  end

  def load_reviews(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ',')

    csv.each do |row|
        review_hash =  {}
        review_hash[:movie_name] = row['Movie']
        review_hash[:rating] = row['Stars']
        review_hash[:comments] = row['Review']

        user = User.find_by(name: row['User'])
        movie = Movie.find_by(title: review_hash[:movie_name])

        if user.nil? 
            user = User.create(name: row['User'])
        end

        review_hash[:user_id] = user.id

        if movie.nil?
            Rails.logger.info("Loading review failed, movie not created: #{review_hash[:movie_name]}")
            next
        else
            review_hash[:movie_id] = movie.id
        end
        Rails.logger.info("Loading review - user: #{row['User']}")
        Review.find_or_create_by!(review_hash)
    end
  end

  private

    def validate_cast(movie_hash, movie)
        cast_member = CastMember.where(name: movie_hash[:actor], movie_id: movie.id).first

        if cast_member.nil?
            Rails.logger.info("Loading movie actor: #{movie_hash[:actor]}")
            CastMember.create(movie_id: movie.id, name: movie_hash[:actor])
        end

    end

    def validate_location(movie_hash, movie)
        location = Location.where(movie_id: movie.id, name: movie_hash[:location]).first
        country_data = Country.where(name: movie_hash[:country]).first

        if location.nil?
            Rails.logger.info "Creating location #{movie_hash[:location]} with country #{country_data.name}"
            Location.create(movie_id: movie.id, country_id: country_data.id, name: movie_hash[:location])
        end
    end
end