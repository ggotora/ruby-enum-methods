module Enumerable
  def my_each
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

end

include Enumerable
array1 = ["hi", 34, "potatoes", "horses", 33]

puts "my_each output\:";puts ""
array1.my_each { |item| puts item }
puts "-----"
array1.each { |item| puts item }
puts "------------"
array1.my_each_with_index {|item, index| puts "#{item} : #{index} "}

