# rubocop: disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength,  Layout/EmptyLines

module Enumerable
  # =========
  #  my_each
  # =========

  def my_each(_arr = nil)
    return to_enum unless block_given?

    arr_size = Array(self).length
    arr_size.times do |i|
      yield(Array(self)[i])
    end
    self
  end

  # ====================
  #  my_each_with_index
  # ====================

  def my_each_with_index(_arr = nil)
    return to_enum unless block_given?

    arr_size = Array(self).length
    arr_size.times do |i|
      yield(Array(self)[i], i)
    end
    self
  end

  # ===========
  #  my_select
  # ===========

  def my_select(_arr = nil)
    return to_enum unless block_given?

    new_arr = []
    arr_size = Array(self).length
    arr_size.times do |x|
      new_arr.push(Array(self)[x]) if yield(Array(self)[x])
    end
    new_arr
  end

  # ========
  #  my_all
  # ========

  def my_all?(arg = nil)
    result = false

    if !arg.nil? && arg.is_a?(Class)
      my_each { |i| return result unless i.is_a?(arg) }
    elsif !arg.nil? && arg.is_a?(Integer)
      my_each { |x| return result unless x == arg }
    elsif !arg.nil? && arg.is_a?(Regexp) || arg.is_a?(String)
      my_each { |y| return result unless y.match(arg) }
    elsif !block_given?
      my_each { |a| return result if a.nil? || !a }
    elsif block_given?
      my_each { |b| return result unless yield(b) }
    end
    !result
  end

  # ========
  #  my_any
  # ========

  def my_any?(arg = nil)
    result = true

    if !arg.nil? && arg.is_a?(Class)
      my_each { |i| return result if i.is_a?(arg) }
    elsif !arg.nil? && arg.is_a?(Integer)
      my_each { |x| return result if x == arg }
    elsif !arg.nil? && arg.is_a?(Regexp) || arg.is_a?(String)
      my_each { |y| return result if y.match(arg) }
    elsif !block_given?
      my_each { |a| return result unless a.nil? || !a }
    elsif block_given?
      my_each { |b| return result if yield(b) }
    end
    !result
  end

  # ==========
  #  my_none?
  # ==========

  def my_none?(arg = nil)
    result = false

    if !arg.nil? && arg.is_a?(Class)
      my_each { |i| return result if i.is_a?(arg) }
    elsif !arg.nil? && arg.is_a?(Integer)
      my_each { |x| return result if x == arg }
    elsif !arg.nil? && arg.is_a?(Regexp) || arg.is_a?(String)
      my_each { |y| return result if y.match(arg) }
    elsif !block_given?
      my_each { |a| return result unless a.nil? || !a }
    elsif block_given?
      my_each { |b| return result if yield(b) }
    end
    !result
  end

  # ==========
  #  my_count
  # ==========

  def my_count(count_one = nil)
    arr_size = Array(self).length
    count = 0

    unless block_given?
      return arr_size if count_one.nil?

      arr_size.times do |i|
        count += 1 if Array(self)[i] == count_one
      end
    end

    if block_given? && !Array(self).nil?
      arr_size.times do |i|
        count += 1 if yield(Array(self)[i])
      end
    end
    count
  end

  # ========
  #  my_map
  # ========

  def my_map(proc = nil)
    return to_enum unless block_given? || proc

    new_arr = []
    proc ? my_each { |i| new_arr << proc.call(i) } : my_each { |i| new_arr << yield(i) }
    new_arr
  end

  # ===========
  #  my_inject
  # ===========

  def my_inject(*arg)
    return yield arg if !block_given? && arg[0].nil?

    arr = Array(self)

    arg_one = arg[0]
    arg_two = arg[1]
    arg_two = arg_one if arg_two.nil?

    if arg_one.nil? || arg_one.is_a?(Symbol)
      arr = drop(1)
      arg_one = to_a[0]
    else
      arr = to_a
    end

    if block_given?
      arr.my_each do |i|
        arg_one = yield(arg_one, i)
      end
    else
      arr.my_each do |i|
        arg_one = arg_one.send(arg_two, i)
      end
    end
    arg_one
  end
end

# =============
#  multiply_els
# =============

def multiply_els(arr)
  arr.my_inject(:*)
end



# rubocop: enable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Layout/EmptyLines

include Enumerable
array = [2, 7, 5, 9]
array1 = ['hi', 34, 'potatoes', 'horses', 33]
array2 = [2, 7, 8, 5]
hash = { a: 1, b: 2, c: 3, d: 4, e: 5 }
block = proc { |num| num }
my_proc = proc { |num| num > 10 }
range = (5..10)
true_block = proc { |num| num <= 9 }
false_block = proc { |num| num >= 9 }
false_array = [nil, false, nil, false]
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
puts
puts "\Array.my_all?(&true_block)\:"; puts ''
p array.my_all?(&true_block)
puts
puts "\Array.my_all?(&false_block)\:"; puts ''
p array.my_all?(&false_block)

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
puts
puts "\Array.all?(&true_block)\:"; puts ''
p array.all?(&true_block)
puts
puts "\Array.my_all?(&false_block)\:"; puts ''
p array.all?(&false_block)


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
puts ''; puts "\Range.my_none?\:"; puts ''
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
puts
puts ''; puts "\False_array.my_none?\:"; puts ''
p false_array.my_none?


puts ''; puts "\nnone? output\:"; puts ''
puts ''; puts "\%w[ant bear cat].none? { |word| word.length == 5 }\:"; puts ''
puts %w[ant bear cat].none? { |word| word.length == 5 }
puts
puts ''; puts "\%w[ant bear cat].none? { |word| word.length >= 4 }\:"; puts ''
puts %w[ant bear cat].none? { |word| word.length >= 4 }
puts
puts ''; puts "\Range.none?\:"; puts ''
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
puts
puts ''; puts "\False_array.none?\:"; puts ''
p false_array.none?

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
puts ''; puts "\[2, 5, 3].my_inject\:"; puts ''
puts [2, 5, 3].my_inject
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
puts ''; puts "\[2, 5, 3].inject\:"; puts ''
puts [2, 5, 3].minject
puts
puts ''; puts "\longest\:"; puts ''
puts longest

puts ''; puts "\nmultiply_els output\:"; puts ''
puts multiply_els([2, 4, 5])