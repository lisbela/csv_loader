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
        actor = row['Actor']
        location_name = row['Filming location']
        country_name = row['Country']

        movie = Movie.find_by(title: movie_hash[:title])
        
        if movie
            Rails.logger.info("Movie already exists in database: #{movie_hash[:title]}")
        else
            Rails.logger.info("Loading movie: #{movie_hash[:title]}")
            movie = Movie.create(movie_hash)
        end

        country = Country.find_or_create_by!(name: country_name)
    
        validate_cast(actor, movie.id)
        validate_location(location_name, country, movie.id)
    end
  end

  def load_reviews(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ',')

    csv.each do |row|
        review_hash =  {}
        review_hash[:rating] = row['Stars']
        review_hash[:comments] = row['Review']

        user = User.find_by(name: row['User'])
        movie = Movie.find_by(title: row['Movie'])

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

    def validate_cast(actor, movie_id)
        cast_member = CastMember.where(name: actor, movie_id: movie_id).first

        if cast_member.nil?
            Rails.logger.info("Loading movie actor: #{actor}")
            CastMember.create(movie_id: movie_id, name: actor)
        end

    end

    def validate_location(location, country, movie_id)
        location = Location.where(movie_id: movie_id, name: location).first

        if location.nil?
            Rails.logger.info "Creating location #{location} with country #{country.name}"
            Location.create(movie_id: movie_id, country_id: country.id, name: location)
        end
    end
end