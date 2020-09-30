# rubocop: disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength,  Layout/EmptyLines, Layout/TrailingEmptyLines

module Enumerable

  def my_each(_arr = nil)
    return to_enum unless block_given?

    arr_size = Array(self).length
    arr_size.times do |i|
      yield(Array(self)[i])
    end
    self
  end
  
  def my_each_with_index(_arr = nil)
    return to_enum unless block_given?

    arr_size = Array(self).length
    arr_size.times do |i|
      yield(Array(self)[i], i)
    end
    self
  end

  def my_select(_arr = nil)
    return to_enum unless block_given?

    new_arr = []
    arr_size = Array(self).length
    arr_size.times do |x|
      new_arr.push(Array(self)[x]) if yield(Array(self)[x])
    end
    new_arr
  end

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

  def my_map(proc = nil)
    return to_enum unless block_given? || proc

    new_arr = []
    proc ? my_each { |i| new_arr << proc.call(i) } : my_each { |i| new_arr << yield(i) }
    new_arr
  end

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

def multiply_els(arr)
  arr.my_inject(:*)
end



# rubocop: enable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength, Layout/EmptyLines, Layout/TrailingEmptyLines
