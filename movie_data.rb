class MovieData

  def initialize(filename)
    @data = Array.new
    File.foreach(filename) { |line| @data.push(line.split(" ")) }
    @user_ids = @data.map { |item| item[0].to_i }.uniq
    @movie_ids = @data.map { |item| item[1].to_i }.uniq
  end

  # Returns an integer from 1 to 5 to indicate the popularity of a certain movie.
  def popularity(movie_id)
    subdata = @data.select { |item| item[1].to_i == movie_id }.map { |item| item[2].to_i }
    subdata.reduce(:+) / subdata.length
  end
  
  # Generates a list of all movie_id’s ordered by decreasing popularity
  def popularity_list
    @movie_ids.sort_by { |movie_id| -popularity(movie_id) }
  end

  # Generates a number between 0 and 1 indicating the similarity in movie preferences between user1 and user2. 0 is no similarity.
  def similarity(user1, user2)
    user1_rate = compute_user_rate(user1)
    user2_rate = compute_user_rate(user2)
    dot_product = user1_rate.reduce(0) { |sum, (k, v)| sum + v * user2_rate[k] }
    user1_magnitude = compute_magnitude(user1_rate)
    user2_magnitude = compute_magnitude(user2_rate)
    dot_product / (user1_magnitude * user2_magnitude)
  end

  # Compute the user_rate hash
  def compute_user_rate(user)
    user_rate = Hash.new(0)
    user_movies = @data.select { |item| item[0].to_i == user }.each { |item| user_rate[item[1].to_i] = item[2].to_i }
    user_rate
  end

  # Compute the magnitude for the user_rate
  def compute_magnitude(user_rate)
    Math.sqrt(user_rate.values.reduce { |sum, v| sum + v ** 2})
  end

  # Return a list of users whose tastes are most similar to the tastes of user u
  def most_similar(u)
    @user_ids.select { |user| u != user }.sort_by { |user| -similarity(u, user) }.first(10)
  end
end