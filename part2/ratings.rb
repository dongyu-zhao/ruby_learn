require 'set'

class Ratings
  def initialize(filename)
    @data = Array.new
    File.foreach(filename) { |line| @data.push(line.split("\t").first(3).map { |x| x.to_i }) }
    @user_ids = @data.map { |item| item[0] }.uniq
    @users = nil
  end

  def data
    @data
  end

  # Generates a number between 0 and 1 indicating the similarity in movie preferences between user1 and user2. 0 is no similarity.
  def similarity(user1, user2, user_rates)
    user1_rate = user_rates[user1]
    user2_rate = user_rates[user2]
    dot_product = user1_rate.reduce(0) { |sum, (k, v)| sum + v * user2_rate[k] }
    user1_magnitude = compute_magnitude(user1_rate)
    user2_magnitude = compute_magnitude(user2_rate)
    dot_product / (user1_magnitude * user2_magnitude)
  end

  # Compute the user_rate hash
  def compute_user_rates
    user_rates = {}
    @user_ids.each do |id|
      user_rate = Hash.new(0)
      @data.select { |item| item[0] == id }.each { |item| user_rate[item[1]] = item[2] }
      user_rates[id] = user_rate
    end
    user_rates
  end

  def compute_similarity_matrix
    matrix = []
    i = 0
    loop do
      matrix.push(Array.new(@user_ids.length, 1))
      i += 1
      if i >= @user_ids.length
        break
      end
    end
    user_rates = compute_user_rates
    i = 0
    loop do
      if i >= @user_ids.length
        break
      end
      j = i + 1
      loop do
        if j >= @user_ids.length
          break
        end
        temp = similarity(@user_ids[i], @user_ids[j], user_rates)
        matrix[i][j] = temp
        matrix[j][i] = temp
        j += 1
      end
      i += 1
    end
    matrix
  end

  # Compute the magnitude for the user_rate
  def compute_magnitude(user_rate)
    Math.sqrt(user_rate.values.reduce { |sum, v| sum + v ** 2})
  end

  # Return a list of users whose tastes are most similar to the tastes of user u
  def compute_most_similar_users
    matrix = compute_similarity_matrix
    users = {}
    @user_ids.each_with_index { |id, ix| users[id] = @user_ids.select { |id2| id2 != id }.map.with_index { |id2, ix2| [id2, matrix[ix][ix2]] }.sort_by { |item| -item[1] }.to_h }
    users
  end

  def predict(user, movie)
    if @users.nil?
      @users = compute_most_similar_users
    end
    similarity = @data.select { |item| @users[user].key?(item[0]) && movie == item[1] }.map {|item| [item[2], @users[user][item[0]]] }
    sum = similarity.reduce(0) { |sum, item| sum += item[1] }
    if sum == 0
	return 0
    else
	return (similarity.reduce(0) { |sum, item| sum + item[0] * item[1] }  / sum).round()
    end  
  end
end
