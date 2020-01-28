class Validator

  def validate(train, test)
    result = test.data.map { |item| [train.predict(item[0], item[1]), item[2]] }

    mean = result.reduce(0) { |sum, x| sum += (x[0] - x[1]).abs } / result.length.to_f
    std = Math.sqrt(result.reduce(0) { |sum, x| sum += (x[0] - x[1]) ** 2 / result.length.to_f })
    groups = result.group_by { |x| (x[0] - x[1]).abs }.map { |k, v| [k, v.length] }
    puts "The mean is #{mean}"
    puts "The std is #{std}"
    puts "The corresponding counts for each difference are: (the first number represents the diff, the second represents the count)"
    p groups
  end
end
