# rubocop : disable  Style/Semicolon, Lint/AmbiguousBlockAssociation, Style/MixinUsage, Lint/UselessAssignment, Lint/ParenthesesAsGroupedExpression

module Enumerable
  def my_each
<<<<<<< HEAD
    for item in self
      yield(item)
    end
    self
||||||| merged common ancestors
    return to_enum unless block_given?

    length.times { |index| yield(self[index]) }
=======
    for item in self 
      yield(item)
    end
    self
>>>>>>> 6c88c1864fb5ccc878748c33724ca88c45d45724
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    my_select = []
    my_each { |item| my_select << item if yield item }
    my_select
  end

  def my_all?(&block)
    unless block_given?
      my_each { |item| return false if item == false || item.nil? }
      return true
    end
    my_selection = my_select(&block)
    return true if self == my_selection

    false
  end

  def my_any?(&block)
    !my_none?(&block)
  end

  def my_none?
    unless block_given?
      my_each { |item| return false if item }
      return true
    end
    my_each { |item| return false if yield(item) }
    true
  end

  def my_count(&block)
    count = 0
    unless block_given?
      count = length
      return count
    end
    count = my_select(&block).length
  end

  def my_map()
    array = to_a
    mapped_array = []
    unless block_given?
      mapped_array = array.to_enum
      return mapped_array
    end
    array.my_each { |item| mapped_array << yield(item) }
    mapped_array
  end

  def my_inject(*arguments)
    array = to_a
    if arguments.length.positive? && arguments[0].class != Symbol
      accumulator = arguments[0]
      array.my_each { |item| accumulator = yield(accumulator, item) }

    elsif arguments.length.zero?
      accumulator = to_a[0]
      array[1..-1].my_each { |item| accumulator = yield(accumulator, item) }
    elsif arguments[0].class == Symbol
      accumulator = to_a[0]
      operation = arguments[0]
      array[1..-1].my_each { |item| accumulator = accumulator.send(operation, item) }
    end
    accumulator
  end

  def multiply_els(array)
    array.my_inject { |product, n| product * n }
  end
end

include Enumerable
array1 = ['hi', 34, 'potatoes', 'horses', 33]
array2 = [2, 7, 8, 5]
range = (5..10)
puts "\nmy_each output\:"; puts ''
array1.my_each { |item| puts item }
p array2.my_each { |item|  item }
range.my_each { |item| puts item}


puts "\neach output\:"; puts ''
array1.each { |item| puts item }

puts "\nmy_each_with_index output\:"; puts ''
array1.my_each_with_index { |item, index| puts "#{item} : #{index} " }


puts "\neach_with_index output\:"; puts ''
array1.each_with_index { |item, index| puts "#{item} : #{index} " }

puts "\nmy_select output\:"; puts ''
puts array1.my_select { |item| item.to_s.length > 2 }

puts "\nselect output\:"; puts ''
puts array1.select { |item| item.to_s.length > 2 }

puts ''; puts "my_all? output\:"; puts ''
puts %w[lul what potatoes uhh].my_all? { |word| word.length >= 3 }
puts ['lul', 'what', 'potatoes', 'uhh', nil].my_all?

puts ''; puts "all? output\:"; puts ''
puts %w[lul what potatoes uhh].all? { |word| word.length >= 3 }
puts ['lul', 'what', 'potatoes', 'uhh', nil].all?

puts ''; puts "\nany? output\:"; puts ''
puts %w[ant bear cat].any? { |word| word.length >= 3 }
puts %w[ant bear cat].any? { |word| word.length >= 4 }
puts [].any?
puts [nil].any?
puts [nil, false].any?

puts ''; puts "\nmy_any? output\:"; puts ''
puts %w[ant bear cat].my_any? { |word| word.length >= 3 }
puts %w[ant bear cat].my_any? { |word| word.length >= 4 }
puts [].my_any?
puts [nil].my_any?
puts [nil, false].my_any?

puts ''; puts "\nmy_none? output\:"; puts ''
puts %w[ant bear cat].my_none? { |word| word.length == 5 }
puts %w[ant bear cat].my_none? { |word| word.length >= 4 }
puts [].my_none?
puts [nil].my_none?
puts [nil, false].my_none?

puts ''; puts "\nnone? output\:"; puts ''
puts %w[ant bear cat].none? { |word| word.length == 5 }
puts %w[ant bear cat].none? { |word| word.length >= 4 }
puts [].none?
puts [nil].none?
puts [nil, false].none?

puts ''; puts "\nmy_count output\:"; puts ''
puts %w[ant bear cat].my_count
puts %w[ant bear cat].my_count { |word| word.length >= 4 }
puts [1, 2, 4, 2].count(&:even?)

puts ''; puts "\ncount output\:"; puts ''
puts %w[ant bear cat].count
puts %w[ant bear cat].count { |word| word.length >= 4 }
puts [1, 2, 4, 2].count(&:even?)

testyproc = proc { |i| i * i }

puts ''; puts "\nmy_map output\:"; puts ''
p(1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
p(1..4).my_map { 'cat' } #=> ["cat", "cat", "cat", "cat"]
p (1..4).my_map(&testyproc)

longest = %w[cat sheep bear].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts ''; puts "\nmy_inject output\:"; puts ''
puts ((5..10).my_inject { |sum, n| sum + n })
puts (5..10).my_inject { |product, n| product * n }
puts longest

longest = %w[cat sheep bear].inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts ''; puts "\ninject output\:"; puts ''
puts ((5..10).inject { |sum, n| sum + n })
puts (5..10).inject { |product, n| product * n }
puts longest

puts ''; puts "\nmultiply_els output\:"; puts ''
puts multiply_els([2, 4, 5])

# rubocop : enable  Style/Semicolon, Lint/AmbiguousBlockAssociation, Style/MixinUsage, Lint/UselessAssignment, Lint/ParenthesesAsGroupedExpression
