module Enumerable
  def my_each(arr)
    arr.length.times { |i| yield(arr[i]) }    
  end
end

include Enumerable
Enumerable.my_each([1, 3, 5,]) { |el| puts el}