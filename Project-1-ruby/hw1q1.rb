class Array
    # redefine to exactly how select method works
    def select
        result = []
        # << is used for appending item onto a list
        each { |item| result << item if yield(item) }
        result
    end
    # redefine to exactly how map method work
    def map
        result = []
        each {|item| result << yield(item)}
        result
    end
    # redefine to exactly how reverse method work
    def reverse
        result = []
        (size - 1).downto(0) { |i| result << self[i] }
        result
    end
end
  
nums = [1,2,3,4,5,6]
print('The array is ',nums,"\n")
#even = nums.my_select{|x| x.even?}
#double = nums.my_map{|x| 2*x}
#reverse = nums.my_reverse()
original_even = nums.select{|x| x.even?}
original_double = nums.map{|x| 2*x}
original_reverse = nums.reverse()
# print(even,"\n")
# print(double,"\n")
# print(reverse)
print('The selected even numbers ',original_even,"\n")
print('The mapped double numbers ',original_double,"\n")
print('The reversed numbers ',original_reverse)