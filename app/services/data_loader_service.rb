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
  
          Country.find_or_create_by!(name: country_name)
          validate_cast(actor, movie)
          validate_location(location_name, country_name, movie)
      end
    end
  
    def load_reviews(file)
      file = File.open(file)
      csv = CSV.parse(file, headers: true, col_sep: ',')
  
      csv.each do |row|
          review_hash =  {}
          movie_name = row['Movie']
          user_name = row['User']
          review_hash[:rating] = row['Stars']
          review_hash[:comments] = row['Review']
  
          user = User.find_by(name: user_name)
          movie = Movie.find_by(title: movie_name)
  
          if user.nil? 
              user = User.create(name: user_name)
          end
  
          review_hash[:user_id] = user.id
  
          if movie.nil?
              Rails.logger.info("Loading review failed, movie not created: #{movie_name}")
              next
          else
              review_hash[:movie_id] = movie.id
          end
          Rails.logger.info("Loading review - user: #{user_name}")
          Review.find_or_create_by!(review_hash)
      end
    end
  
    private
  
      def validate_cast(actor, movie)
          cast_member = CastMember.where(name: actor, movie_id: movie.id).first
  
          if cast_member.nil?
              Rails.logger.info("Loading movie actor: #{actor}")
              CastMember.create(movie_id: movie.id, name: actor)
          end
  
      end
  
      def validate_location(location_name, country_name, movie)
          location = Location.where(movie_id: movie.id, name: location_name).first
          country_data = Country.where(name: country_name).first
  
          if location.nil?
              Rails.logger.info "Creating location #{location_name} with country #{country_data.name}"
              Location.create(movie_id: movie.id, country_id: country_data.id, name: location_name)
          end
      end
 end