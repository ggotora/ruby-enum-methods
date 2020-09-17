# rubocop : disable  Style/Semicolon, Lint/AmbiguousBlockAssociation, Style/MixinUsage, Lint/UselessAssignment, Lint/Void, Metrics/PerceivedComplexity, Lint/Syntax

module Enumerable
  def my_each
    # An enumerator is returned if no block is given
    return to_enum unless block_given?

    i = 0
    self_class = self.class
    array = if self_class == Array
              self
            elsif self_class == Range
              to_a
            else
              flatten
            end
    while i < array.length
      if self_class == Hash
        yield(array[i], array[i + 1])
        i += 2
      else
        yield(array[i])
        i += 1
      end
    end
  end

  def my_each_with_index
    # If no block is given, an enumerator is returned instead.
    return to_enum unless block_given?

    array = self.class == Array ? self : to_a
    i = 0
    while i < length
      yield(array[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    my_select = []
    my_each { |item| my_select << item if yield item }
    my_select
  end

  def my_all?(parameter = nil)
    return true if (self.class == Array && count.zero?) || (!block_given? &&
        parameter.nil? && !include?(nil))
    return false unless block_given? || !parameter.nil?

    boolean = true
    if self.class == Array
      my_each do |n|
        if block_given?
          boolean = false unless yield(n)
        elsif parameter.class == Regexp
          boolean = false unless n.match(parameter)
        elsif parameter.class <= Numeric
          boolean = false unless n == parameter
        else
          boolean = false unless n.class <= parameter
        end
        break unless boolean
      end
    else
      my_each do |key, value|
        boolean = false unless yield(key, value)
      end
    end
    boolean
  end
  

  def my_any?(obj = nil)
    result = false
    if obj.nil? && !block_given?
      my_each { |i| return !result if i == true }
    elsif !obj.nil? && obj.is_a?(Class)
      my_each { |i| return !result if i.is_a?(obj) }
    elsif obj.is_a? String
      my_each { |i| return !result if obj.match?(i) }
    elsif obj.is_a? Integer
      my_each { |i| return !result if i == obj }
    elsif !obj.nil? && obj.is_a?(Regexp) || obj.is_a?(String)
      my_each { |i| return !result if i.match(obj) }
    elsif block_given?
      my_each { |i| return !result if yield(i) }
    end
    result
  end

  def my_none?(obj = nil)
    result = true
    if obj.nil? && !block_given?
      my_each { |i| return !result if i.nil? || !i }
    elsif !obj.nil? && obj.is_a?(Class)
      my_each { |i| return !result if i.is_a?(obj) }
    elsif obj.is_a?(String) && !is_a?(Range)
      my_each { |i| return !result if i.match?(obj) }
    elsif obj.is_a? Integer
      my_each { |i| return !result if i == obj }
    elsif !obj.nil? && obj.is_a?(Regexp) || obj.is_a?(String)
      my_each { |i| return !result if i.match(obj) }
    elsif block_given?
      my_each { |i| return !result if yield(i) }
    end
    result
  end

  def my_count(param = nil)
    count = 0
    if block_given?
      to_a.my_each { |item| count += 1 if yield(item) }
    elsif !block_given? && param.nil?
      count = to_a.length
    else
      count = to_a.my_select { |item| item == param }.length
    end
    count
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
hash = { a: 1, b: 2, c: 3, d: 4, e: 5 }
range = (5..10)

puts "\nmy_each output\:"; puts ''
array1.my_each { |item| puts item }
p array2.each { |item| item }
range.my_each { |item| puts item }
hash.my_each { |item, index| puts "#{item} : #{index} " }

puts "\neach output\:"; puts ''
array1.each { |item| puts item }
p array2.each { |item| item }
range.each { |item| puts item }
hash.each { |item, index| puts "#{item} : #{index} " }

puts "\nmy_each_with_index output\:"; puts ''
array1.my_each_with_index { |item, index| puts "#{item} : #{index} " }
p array2.my_each_with_index { |item, index| "#{item} : #{index} " }
range.each { |item| puts item }
hash.my_each_with_index { |item, index| puts "#{item} : #{index} " }

puts "\neach_with_index output\:"; puts ''
array1.each_with_index { |item, index| puts "#{item} : #{index} " }
p array2.each_with_index { |item, index| "#{item} : #{index} " }
range.each { |item| puts item }
hash.my_each_with_index { |item, index| puts "#{item} : #{index} " }

puts "\nmy_select output\:"; puts ''
puts array1.my_select { |item| item.to_s.length > 2 }
p array2.my_select { |item| item }
range.my_select { |item| puts item }

puts "\nselect output\:"; puts ''
puts array1.select { |item| item.to_s.length > 2 }
p array2.select { |item| item }
range.my_select { |item| puts item }

puts ''; puts "\nmy_all? output\:"; puts ''
puts (%w[lul what potatoes uhh].my_all? { |word| word.length >= 3 })
puts (['lul', 'what', 'potatoes', 'uhh', nil].my_all?)
puts ([1, 2, 3].my_all?(Integer))
puts (['hi', 'hello', 'hey'].my_all?(/d/))
puts ([3, 3, 3].my_all?(3))

puts ''; puts "\nall? output\:"; puts ''
puts (%w[lul what potatoes uhh].all? { |word| word.length >= 3 })
puts (['lul', 'what', 'potatoes', 'uhh', nil].all?)
puts ([1, 2, 3].all?(Integer))
puts (['hi', 'hello', 'hey'].all?(/d/))
puts ([3, 3, 3].all?(3))

puts ''; puts "\nany? output\:"; puts ''
puts %w[ant bear cat].any? { |word| word.length >= 3 }
puts %w[ant bear cat].any? { |word| word.length >= 4 }
puts range.any?
puts [].any?
puts [nil].any?
puts [nil, false].any?
puts ([1, 2, 3].any?(Integer))
puts (['hi', 'hello', 'hey'].any?(/d/))
puts ([3, 3, 3].any?(3))

puts ''; puts "\nmy_any? output\:"; puts ''
puts %w[ant bear cat].my_any? { |word| word.length >= 3 }
puts %w[ant bear cat].my_any? { |word| word.length >= 4 }
puts range.my_any?
puts [].my_any?
puts [nil].my_any?
puts [nil, false].my_any?
puts ([1, 2, 3].my_any?(Integer))
puts (['hi', 'hello', 'hey'].my_any?(/d/))
puts ([3, 3, 3].my_any?(3))

puts ''; puts "\nmy_none? output\:"; puts ''
puts %w[ant bear cat].my_none? { |word| word.length == 5 }
puts %w[ant bear cat].my_none? { |word| word.length >= 4 }
puts range.my_none?
puts [].my_none?
puts [nil].my_none?
puts [nil, false].my_none?
puts [1, 2, 3].my_none?(String)
puts ['hi', 'hello', 'hey'].my_none?(/d/) #false
puts [3, 3, 3].my_none?(3)

puts ''; puts "\nnone? output\:"; puts ''
puts %w[ant bear cat].none? { |word| word.length == 5 }
puts %w[ant bear cat].none? { |word| word.length >= 4 }
puts range.none?
puts [].none?
puts [nil].none?
puts [nil, false].none?
puts [1, 2, 3].none?(String)
puts ['hi', 'hello', 'hey'].none?(/d/) # true
puts [3, 3, 3].none?(3)

puts ''; puts "\nmy_count output\:"; puts ''
puts %w[ant bear cat].my_count
puts %w[ant bear cat].my_count { |word| word.length >= 4 }
puts [1, 2, 4, 2].count(&:even?)
puts range.my_count
puts [1, 2, 3].my_count(3)

puts ''; puts "\ncount output\:"; puts ''
puts %w[ant bear cat].count
puts %w[ant bear cat].count { |word| word.length >= 4 }
puts [1, 2, 4, 2].count(&:even?)
puts range.count
puts [1, 2, 3].count(3)

# testyproc = proc { |i| i * i }

# puts ''; puts "\nmy_map output\:"; puts ''
# p(1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
# p(1..4).my_map { 'cat' } #=> ["cat", "cat", "cat", "cat"]
# p (1..4).my_map(&testyproc)

# longest = %w[cat sheep bear].my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end

# puts ''; puts "\nmy_inject output\:"; puts ''
# puts ((5..10).my_inject { |sum, n| sum + n })
# puts (5..10).my_inject { |product, n| product * n }
# puts longest

# longest = %w[cat sheep bear].inject do |memo, word|
#   memo.length > word.length ? memo : word
# end

# puts ''; puts "\ninject output\:"; puts ''
# puts ((5..10).inject { |sum, n| sum + n })
# puts (5..10).inject { |product, n| product * n }
# puts longest

# puts ''; puts "\nmultiply_els output\:"; puts ''
# puts multiply_els([2, 4, 5])

# rubocop : enable  Style/Semicolon, Lint/AmbiguousBlockAssociation, Style/MixinUsage, Lint/UselessAssignment, Lint/Void, Lint/Syntax, Metrics/PerceivedComplexity