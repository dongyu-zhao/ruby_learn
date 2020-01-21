require_relative 'movie_data'
movie_data = MovieData.new("u.data")

popularity_list = movie_data.popularity_list
p "First movie id of popularity list"
puts popularity_list.first
p "Last 10 movie ids of popularity list"
puts popularity_list.last(10)
p "10 most similar users'id  with user_id 1"
puts movie_data.most_similar(1)