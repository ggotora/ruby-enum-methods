module Enumerable
  def my_each
    return to_enum unless block_given?
   (self.length).times { |index| yield(self[index]) }
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
    return self.to_enum if !(block_given?)
      my_select = []
      self.my_each { |item| my_select << item if yield (item) }
      my_select
  end

end

include Enumerable
array1 = ["hi", 34, "potatoes", "horses", 33]

puts "\nmy_each output\:";puts""
array1.my_each { |item| puts item }

puts "\neach output\:";puts""
array1.each { |item| puts item }

puts "\nmy_each output\:";puts""
array1.my_each_with_index {|item, index| puts "#{item} : #{index} "}

puts "\nmy_select output\:";puts""
puts array1.my_select { |item| item.to_s.length > 2}

puts "\nselect output\:";puts""
puts array1.select { |item| item.to_s.length > 2}

