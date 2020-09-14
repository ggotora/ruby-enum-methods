module Enumerable
  def my_each
    return to_enum unless block_given?

    length.times { |index| yield(self[index]) }
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

  # def my_all
  #   all_el = true
  #   self.my_each do ||
  #      unless yield(item)
  #        all_el = false
  #     end
  #   end
  # end

  def my_all?(&block)
    if !(block_given?)
      self.my_each { |item| return false if item == false || item == nil }
      return true
    end
    my_selection = my_select(&block)
    return true if self == my_selection
    false
  end

  def my_any?
    my_each do |i|
      if yield(self[i] == true)
        return true
      else
        return false
      end
    end
    # my_each(arr) do |i|
    #   if yield(arr[i] == true)
    #    return true
    #   else
    #     return false
    #   end
    # end
  end
end

include Enumerable
array1 = ['hi', 34, 'potatoes', 'horses', 33]

puts "\nmy_each output\:"; puts ''
array1.my_each { |item| puts item }

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

puts "\nmy_any? output\:"; puts ''

puts %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
puts %w[ant bear cat].any?(/d/)                        #=> false
puts [nil, true, 99].any?(Integer)                     #=> true
puts [nil, true, 99].any?                              #=> true
puts [].any?                                           #=> false
