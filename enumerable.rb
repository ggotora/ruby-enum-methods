# rubocop: disable Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Lint/InterpolationCheck

module Enumerable
  def my_each(_array = nil)
    return to_enum unless block_given?

    Array(self).length.times do |i|
      yield(Array(self)[i])
    end
    self
  end

  def my_each_with_index(_array = nil)
    return to_enum unless block_given?

    Array(self).length.times do |index|
      yield(to_a[index], index)
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    result = []
    my_each do |item|
      result.push(item) if yield(item)
    end
    result
  end

  def my_all?(obj = nil)
    result = true

    if obj.nil? && !block_given?
      my_each { |i| return !result if i.nil? || !i }
    elsif !obj.nil? && obj.is_a?(Class)
      my_each { |i| return !result unless i.is_a?(obj) }
    elsif obj.is_a? Integer
      my_each { |i| return !result unless i == obj }
    elsif !obj.nil? && obj.is_a?(Regexp) || obj.is_a?(String)
      my_each { |i| return !result unless i.match(obj) }
    elsif obj.is_a? Array
      return !result unless obj.sort == sort
    elsif block_given?
      my_each { |i| return !result if yield(i) }
    end
    result
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

  def my_count(obj = nil)
    counter = 0
    if obj.nil? && !block_given?
      my_each { |_i| counter += 1 }
    elsif obj.nil? && block_given?
      my_each { |i| counter += 1 if yield(i) }
    elsif obj.is_a? Integer
      my_each { |i| counter += 1 if i == obj }
    elsif obj.is_a? String
      my_each { |i| counter += 1 if i.match?(obj) }
    end
    counter
  end

  def my_map(var = nil)
    return to_enum unless block_given? || var

    result = []
    if block_given? && var.nil?
      my_each do |n|
        result.push(yield(n))
      end
    else
      my_each do |n|
        result.push(var.call(n))
      end
    end
    result
  end

  def my_inject(*obj)
    raise 'LocalJumpError: Block or argument missing!' if !block_given? && obj[0].nil?

    result = Array(self)[0]

    is_symbol = false
    if (obj[0].class == Symbol) || obj[0].nil?
      is_symbol = true
    elsif obj[0].is_a? Numeric
      result = obj[0]
    end

    Array(self).my_each_with_index do |item, index|
      next if is_symbol && index.zero?

      if block_given?
        result = yield(result, item)
      elsif obj[0].is_a? Numeric
        result = result.send(obj[1], item)
      elsif obj[0].class == Symbol
        result = result.send(obj[0], item)
      end
    end
    result
  end

  def multiply_els(arr)
  arr.my_inject { |product, n| product * n }
  end
end



include Enumerable
array1 = ['hi', 34, 'potatoes', 'horses', 33]
array2 = [2, 7, 8, 5]
hash = { a: 1, b: 2, c: 3, d: 4, e: 5 }
block = proc { |num| num }
my_proc = proc { |num| num > 10 }
range = (5..10)
# range = Range.new(5, 50)

puts "\nmy_each output\:"; puts ''
array1.my_each { |item| puts item }
puts
puts "\Array_method_1\:"; puts ''
p array2.each { |item| item }
puts
puts "\Array_method_2(&block)\:"; puts ''
p array2.my_each(&block)
puts
puts "\Range_method_1\:"; puts ''
range.my_each { |item| puts item }
puts
puts "\Range_method_2(&block)\:"; puts ''
p range.my_each(&block)
puts
puts "\Hash_method_1\:"; puts ''
(hash.my_each { |item, index| puts "#{item} : #{index} " })
puts
puts "\Hash_method_2(&block)\:"; puts ''
p hash.my_each(&block)

puts "\neach output\:"; puts ''
array1.each { |item| puts item }
puts "\Array_method_1\:"; puts ''
p array2.each { |item| item }
puts
puts "\Array_method_2(&block)\:"; puts ''
p array2.each(&block)
puts
puts "\Range_method_1\:"; puts ''
range.each { |item| puts item }
puts
puts "\Range_method_2(&block)\:"; puts ''
p range.each(&block)
puts
puts "\Hash_method_1\:"; puts ''
hash.each { |item, index| puts "#{item} : #{index} " }
puts
puts "\Hash_method_2(&block)\:"; puts ''
p hash.each(&block)

puts "\nmeach_with_index output\:"; puts ''
array1.my_each_with_index { |item, index| puts "#{item} : #{index} " }
puts
puts "\Array_method_1\:"; puts ''
p array2.my_each_with_index { |item, index| "#{item} : #{index} " }
puts
puts "\Array_method_2(&block)\:"; puts ''
p array2.my_each_with_index(&block)
puts
puts "\Range_method_1\:"; puts ''
range.my_each_with_index { |item| puts item }
puts
puts "\Range_method_2(&block)\:"; puts ''
p range.my_each_with_index(&block)
puts
puts "\Hash_method_1\:"; puts ''
hash.my_each_with_index { |item, index| puts "#{item} : #{index} " }
puts
puts "\Hash_method_2(&block)\:"; puts ''
p hash.my_each_with_index(&block)

puts "\neach_with_index output\:"; puts ''
array1.each_with_index { |item, index| puts "#{item} : #{index} " }
puts
puts "\Array_method_1\:"; puts ''
p array2.each_with_index { |item, index| "#{item} : #{index} " }
puts
puts "\Array_method_2(&block)\:"; puts ''
p array2.each_with_index(&block)
puts
puts "\Range_method_1\:"; puts ''
range.each_with_index { |item| puts item }
puts
puts "\Range_method_2(&block)\:"; puts ''
p range.each_with_index(&block)
puts
puts "\Hash_method_1\:"; puts ''
hash.each_with_index { |item, index| puts "#{item} : #{index} " }
puts
puts "\Hash_method_2(&block)\:"; puts ''
p hash.each_with_index(&block)


puts "\nmy_select output\:"; puts ''
puts array1.my_select { |item| item.to_s.length > 2 }
puts
puts "\Array_method_1\:"; puts ''
p array2.my_select { |item| item }
puts
puts "\Range_method_1\:"; puts ''
range.my_select { |item| puts item }
puts

puts "\nselect output\:"; puts ''
puts array1.select { |item| item.to_s.length > 2 }
puts
puts "\Array_method_1\:"; puts ''
p array2.select { |item| item }
puts
puts "\Range_method_1\:"; puts ''
range.my_select { |item| puts item }

puts ''; puts "\nmy_all? output\:"; puts ''
puts (%w[lul what potatoes uhh].my_all? { |word| word.length >= 3 })
puts
puts "\['lul', 'what', 'potatoes', 'uhh', nil].my_all?)\:"; puts ''
puts (['lul', 'what', 'potatoes', 'uhh', nil].my_all?)
puts
puts "\([1, 2, 3].my_all?(Integer))\:"; puts ''
puts ([1, 2, 3].my_all?(Integer))
puts
puts "\(%w[hi hello hey].my_all?(/d/))\:"; puts ''
puts (%w[hi hello hey].my_all?(/d/))
puts
puts "\[1, false, 'hi', []].my_all?\:"; puts ''
p [1, false, 'hi', []].my_all?
puts
puts "\([3, 3, 3].my_all?(3))\:"; puts ''
puts ([3, 3, 3].my_all?(3))

puts ''; puts "\nall? output\:"; puts ''
puts (%w[lul what potatoes uhh].all? { |word| word.length >= 3 })
puts
puts "\['lul', 'what', 'potatoes', 'uhh', nil].all?)\:"; puts ''
puts (['lul', 'what', 'potatoes', 'uhh', nil].all?)
puts
puts "\([1, 2, 3].all?(Integer))\:"; puts ''
puts ([1, 2, 3].all?(Integer))
puts
puts "\(%w[hi hello hey].all?(/d/))\:"; puts ''
puts (%w[hi hello hey].all?(/d/))
puts
puts "\[1, false, 'hi', []].all?\:"; puts ''
p [1, false, 'hi', []].all?
puts
puts "\([3, 3, 3].all?(3))\:"; puts ''
puts ([3, 3, 3].all?(3))


puts ''; puts "\nany? output\:"; puts ''
puts ''; puts "\%w[ant bear cat].any? { |word| word.length >= 3 }\:"; puts ''
puts %w[ant bear cat].any? { |word| word.length >= 3 }
puts
puts ''; puts "\%w[ant bear cat].any? { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].any? { |word| word.length >= 4 }
puts
puts ''; puts "\range.any?\:"; puts ''
puts range.any?
puts
puts ''; puts "\[].any?\:"; puts ''
puts [].any?
puts
puts ''; puts "\[nil].any?\:"; puts ''
puts [nil].any?
puts
puts ''; puts "\[nil, false].any?\:"; puts ''
puts [nil, false].any?
puts
puts ''; puts "\([1, 2, 3].any?(Integer))\:"; puts ''
puts ([1, 2, 3].any?(Integer))
puts
puts ''; puts "\(%w[hi hello hey].any?(/d/))\:"; puts ''
puts (%w[hi hello hey].any?(/d/))
puts
puts ''; puts "\([3, 3, 3].any?(3))\:"; puts ''
puts ([3, 3, 3].any?(3))

puts ''; puts "\nmy_any? output\:"; puts ''
puts ''; puts "\%w[ant bear cat].my_any? { |word| word.length >= 3 }\:"; puts ''
puts %w[ant bear cat].my_any? { |word| word.length >= 3 }
puts
puts ''; puts "\%w[ant bear cat].my_any? { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].my_any? { |word| word.length >= 4 }
puts
puts ''; puts "\range.my_any?\:"; puts ''
puts range.my_any?
puts
puts ''; puts "\[].my_any?\:"; puts ''
puts [].my_any?
puts
puts ''; puts "\[nil].my_any?\:"; puts ''
puts [nil].my_any?
puts
puts ''; puts "\[nil, false].my_any?\:"; puts ''
puts [nil, false].my_any?
puts
puts ''; puts "\([1, 2, 3].my_any?(Integer))\:"; puts ''
puts ([1, 2, 3].my_any?(Integer))
puts
puts ''; puts "\(%w[hi hello hey].my_any?(/d/))\:"; puts ''
puts (%w[hi hello hey].my_any?(/d/))
puts
puts ''; puts "\([3, 3, 3].my_any?(3))\:"; puts ''
puts ([3, 3, 3].my_any?(3))

puts ''; puts "\nmy_none? output\:"; puts ''
puts ''; puts "\%w[ant bear cat].my_none? { |word| word.length == 5 }\:"; puts ''
puts %w[ant bear cat].my_none? { |word| word.length == 5 }
puts
puts ''; puts "\%w[ant bear cat].my_none? { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].my_none? { |word| word.length >= 4 }
puts
puts ''; puts "\range.my_none?\:"; puts ''
puts range.my_none?
puts
puts ''; puts "\[].my_none?\:"; puts ''
puts [].my_none?
puts
puts ''; puts "\[nil].my_none?\:"; puts ''
puts [nil].my_none?
puts
puts ''; puts "\[nil, false].my_none?\:"; puts ''
puts [nil, false].my_none?
puts
puts ''; puts "\[1, 2, 3].my_none?(String)\:"; puts ''
puts [1, 2, 3].my_none?(String)
puts
puts ''; puts "\[nil, false, nil, false].my_none?\:"; puts ''
p [nil, false, nil, false].my_none?
puts
puts ''; puts "\%w[hi hello hey].my_none?(/d/)\:"; puts ''
puts %w[hi hello hey].my_none?(/d/)
puts
puts ''; puts "\[3, 3, 3].my_none?(3)\:"; puts ''
puts [3, 3, 3].my_none?(3)

puts ''; puts "\nnone? output\:"; puts ''
puts ''; puts "\%w[ant bear cat].none? { |word| word.length == 5 }\:"; puts ''
puts %w[ant bear cat].none? { |word| word.length == 5 }
puts
puts ''; puts "\%w[ant bear cat].none? { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].none? { |word| word.length >= 4 }
puts
puts ''; puts "\range.none?\:"; puts ''
puts range.none?
puts
puts ''; puts "\[].none?\:"; puts ''
puts [].none?
puts
puts ''; puts "\[nil].none?\:"; puts ''
puts [nil].none?
puts
puts ''; puts "\[nil, false].none?\:"; puts ''
puts [nil, false].none?
puts
puts ''; puts "\[1, 2, 3].none?(String)\:"; puts ''
puts [1, 2, 3].none?(String)
puts
puts ''; puts "\[nil, false, nil, false].none?\:"; puts ''
p [nil, false, nil, false].none?
puts
puts ''; puts "\%w[hi hello hey].none?(/d/)\:"; puts ''
puts %w[hi hello hey].none?(/d/)
puts
puts ''; puts "\[3, 3, 3].none?(3)\:"; puts ''
puts [3, 3, 3].none?(3)

puts ''; puts "\nmy_count output\:"; puts ''
puts ''; puts "\%w[ant bear cat].my_count\:"; puts ''
puts %w[ant bear cat].my_count
puts
puts ''; puts "\%w[ant bear cat].my_count { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].my_count { |word| word.length >= 4 }
puts
puts ''; puts "\[1, 2, 4, 2].my_count(&:even?\:"; puts ''
puts [1, 2, 4, 2].my_count(&:even?)
puts
puts ''; puts "\p range.my_count(&block) =>(5..10)\:"; puts ''
p range.my_count(&block)
puts
puts ''; puts "\puts [1, 2, 3].my_count(3)\:"; puts ''
puts [1, 2, 3].my_count(3)

puts ''; puts "\ncount output\:"; puts ''
puts ''; puts "\%w[ant bear cat].count\:"; puts ''
puts %w[ant bear cat].count
puts
puts ''; puts "\%w[ant bear cat].count { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].count { |word| word.length >= 4 }
puts
puts ''; puts "\[1, 2, 4, 2].count(&:even?)\:"; puts ''
puts [1, 2, 4, 2].count(&:even?)
puts
puts ''; puts "\p range.count(&block) =>(5..10)\:"; puts ''
p range.count(&block)
puts
puts ''; puts "\puts [1, 2, 3].count(3)\:"; puts ''
puts [1, 2, 3].count(3)

my_proc = proc { |i| i * i }

puts ''; puts "\nmy_map output\:"; puts ''
puts ''; puts "\(1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]\:"; puts ''
p (1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
puts
puts ''; puts "\(1..4).my_map { 'cat' } #=> ['cat', 'cat', 'cat', 'cat']\:"; puts ''
p (1..4).my_map { 'cat' } #=> ["cat", "cat", "cat", "cat"]
puts
puts ''; puts "\(1..4).my_map(&my_proc)\:"; puts ''
p (1..4).my_map(&my_proc)
puts
array2.my_map(my_proc) { |num| num < 10 }

longest = %w[cat sheep bear].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts ''; puts "\nmy_inject output\:"; puts ''
puts ''; puts "\((5..10).my_inject { |sum, n| sum + n })\:"; puts ''
puts ((5..10).my_inject { |sum, n| sum + n })
puts
puts ''; puts "\(5..10).my_inject { |product, n| product * n }\:"; puts ''
puts (5..10).my_inject { |product, n| product * n }
puts
puts ''; puts "\[1, 2, 3].my_inject(20, :*)\:"; puts ''
puts [1, 2, 3].my_inject(20, :*)
puts
puts ''; puts "\longest\:"; puts ''
puts longest

longest = %w[cat sheep bear].inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts ''; puts "\ninject output\:"; puts ''
puts ''; puts "\((5..10).inject { |sum, n| sum + n })\:"; puts ''
puts ((5..10).inject { |sum, n| sum + n })
puts
puts ''; puts "\(5..10).inject { |product, n| product * n }\:"; puts ''
puts (5..10).inject { |product, n| product * n }
puts
puts ''; puts "\[1, 2, 3].inject(20, :*)\:"; puts ''
puts [1, 2, 3].inject(20, :*)
puts
puts ''; puts "\longest\:"; puts ''
puts longest

puts ''; puts "\nmultiply_els output\:"; puts ''
puts multiply_els([2, 4, 5])


# rubocop: enable Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Lint/InterpolationCheck
