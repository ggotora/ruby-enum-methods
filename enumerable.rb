# rubocop : disable  Style/Semicolon, Lint/AmbiguousBlockAssociation, Style/MixinUsage
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
    unless block_given?
      my_each { |item| return false if item == false || item.nil? }
      return true
    end
    my_selection = my_select(&block)
    return true if self == my_selection

    false
  end

  def my_any?(&block)
    !(self.my_none?(&block))
  end

  def my_none?
    if !(block_given?)
      self.my_each { |item| return false if item }
      return true
    end
    self.my_each { |item| return false if (yield(item)) }
    true
  end
end

include Enumerable
array1 = ["hi", 34, "potatoes", "horses", 33]

puts "\nmy_each output\:"; puts ""
array1.my_each { |item| puts item }

puts "\neach output\:"; puts ""
array1.each { |item| puts item }

puts "\nmy_each_with_index output\:"; puts ""
array1.my_each_with_index { |item, index| puts "#{item} : #{index} " }

puts "\neach_with_index output\:"; puts ""
array1.each_with_index { |item, index| puts "#{item} : #{index} " }

puts "\nmy_select output\:"; puts ""
puts array1.my_select { |item| item.to_s.length > 2 }

puts "\nselect output\:"; puts ""
puts array1.select { |item| item.to_s.length > 2 }

puts ""; puts "my_all? output\:"; puts ""
puts %w[lul what potatoes uhh].my_all? { |word| word.length >= 3 }
puts ["lul", "what", "potatoes", "uhh", nil].my_all?

puts ""; puts "all? output\:"; puts ""
puts %w[lul what potatoes uhh].all? { |word| word.length >= 3 }
puts ["lul", "what", "potatoes", "uhh", nil].all?

puts ""; puts "\nany? output\:"; puts ""
puts ["ant", "bear", "cat"].any? { |word| word.length >= 3 }
puts ["ant", "bear", "cat"].any? { |word| word.length >= 4 }
puts [].any?
puts [nil].any?
puts [nil,false].any?

puts "";puts "\nmy_any? output\:";puts ""
puts ["ant", "bear", "cat"].my_any? {|word| word.length >= 3}   
puts ["ant", "bear", "cat"].my_any? {|word| word.length >= 4}   
puts [].my_any?
puts [nil].my_any?
puts [nil,false].my_any?


puts "";puts "\nmy_none? output\:";puts ""
puts %w{ant bear cat}.my_none? {|word| word.length == 5}  
puts %w{ant bear cat}.my_none? {|word| word.length >= 4}
puts [].my_none?                                          
puts [nil].my_none?                                       
puts [nil,false].my_none?

puts "";puts "\nnone? output\:";puts ""
puts %w{ant bear cat}.none? {|word| word.length == 5}  
puts %w{ant bear cat}.none? {|word| word.length >= 4}
puts [].none?                                          
puts [nil].none?                                       
puts [nil,false].none?

# rubocop : enable  Style/Semicolon, Lint/AmbiguousBlockAssociation, Style/MixinUsage
