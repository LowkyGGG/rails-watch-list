# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Movie.destroy_all

require 'net/http'
require 'json'

url = URI("https://tmdb.lewagon.com/movie/top_rated")
response = Net::HTTP.get(url)
movies = JSON.parse(response)["results"].sample(15)  # Get 15 random movies

movies.each do |movie_data|
  Movie.find_or_create_by!(title: movie_data["title"]) do |movie|
    movie.overview = movie_data["overview"] if movie_data["overview"].present?
    movie.poster_url = movie_data["poster_path"] if movie_data["poster_path"].present?
    movie.rating = movie_data["vote_average"] if movie_data["vote_average"].present?
  end
end

puts "Created #{Movie.count} movies"
