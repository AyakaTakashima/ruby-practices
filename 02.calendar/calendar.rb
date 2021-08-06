#!/usr/bin/env ruby

require "date"
require "optparse"

options = ARGV.getopts("y:", "m:")

OptionParser.new do |opt|
  opt.on('-y VAL') do |v|
    params[:y] = v.to_i
  end

  opt.on('-m VAL') do |v|
    params[:m] = n.to_i
  end
end.parse!


today = Date.today
date = Date.new

if options["m"]
  month = options["m"].to_i
else
  month = today.mon
end

if options["y"]
  year = options["y"].to_i
else
  year = today.year
end

head = "#{month}月　#{year}年"
puts head.center(16)

weeks = Date.new.wday
week = %w(日 月 火 水 木 金 土)
puts week.join(" ")

days = Date.new(year,month,1).wday 

print "   "*days

date.mday
last_date = Date.new(year,month,-1).mday

(1..last_date).each do |i|
  print "#{i}".rjust(2)
  days += 1
  if days % 7 == 0
    puts
	else
    print " "
  end
end

print("\n")
