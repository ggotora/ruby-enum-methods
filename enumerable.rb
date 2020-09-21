# rubocop: disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength,  Style/MixinUsage, Lint/UselessAssignment, Lint/AmbiguousBlockAssociation, Lint/Void, Lint/RedundantWithIndex, Layout/EmptyLines, Lint/ParenthesesAsGroupedExpression, Style/RedundantParentheses,  Style/Semicolon

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
    raise('LocalJumpError.new NO BLOCK OR ARGUMENT GIVEN!') if !block_given? && arg == nil?

    check = false
    result = Array(self)[0]
    if (arg[0].class == Symbol) || arg[0].nil?
      check = true
    elsif arg[0].is_a? Numeric
      result = arg[0]
    end
    Array(self).my_each_with_index do |item, index|
      next if check && index.zero?

      if block_given?
        result = yield(result, item)
      elsif arg[0].class == Symbol
        result = result.send(arg[0], item)
      elsif arg[0].is_a? Numeric
        result = result.send(arg[1], item)
      end
    end
    result
  end
end

# =============
#  multiply_els
# =============

def multiply_els(arr)
  arr.my_inject(:*)
end


# rubocop: enable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/ModuleLength,  Style/MixinUsage, Lint/UselessAssignment, Lint/AmbiguousBlockAssociation, Lint/Void, Lint/RedundantWithIndex, Layout/EmptyLines, Lint/ParenthesesAsGroupedExpression, Style/RedundantParentheses,  Style/Semicolon
