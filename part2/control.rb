require_relative 'ratings'
require_relative 'validator'
class Control
  def run(train_file, test_file)
    train = Ratings.new(train_file)
    test = Ratings.new(test_file)
    Validator.new.validate(train, test)
  end
end