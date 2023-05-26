# README

This is a Ruby on Rails application that has csv loaders for movies and reviews.

## Installation

1. Clone the repository to your local machine:

   git clone <repository-url>

2. Navigate to the project directory:

   cd project_directory

3. Install the required dependencies:

   bundle install

4. Set up the database:

   rails db:setup

5. Start the Rails server:

   rails server

6. Access the application in your web browser at:

   http://localhost:3000

## Usage

1. Loads movies.csv and reviews.csd files

2. Presents movies sorted by average rating

3. Filters movies by chosen Actor using a serach form

## Tests

Tests generated for movie controller under spec folder. To run use:

    rspec
