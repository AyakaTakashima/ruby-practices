#! /usr/bin/env ruby

(1..20).each do |x|
  unless x % 3 == 0 || x % 5 ==0
    puts x
  end
  if x % 3 == 0 && x % 5 == 0
    puts "FizzBuzz"
  elsif x % 5 == 0
    puts "Buzz"
  elsif x % 3 == 0
    puts "Fizz"
  end
end

