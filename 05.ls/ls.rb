#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

params = ARGV.getopts('alr')

def ls_command
  @all_file = []

  Dir.glob('*') do |item|
    @all_file << item
  end
  
  @all_file.sort!
  a = @all_file.map { |file| file.ljust(17) }

  line = @all_file.size / 4
  
  file_arry = []
  a.each_slice(line) do |a, b, c, d|
    file_arry << [a, b, c, d]
  end
    
  file_column = file_arry.transpose
  
  file_column.each do |x|
    puts x.join(' ')
  end
end

def r_option
  all_file = []
  
  Dir.glob('*') do |item|
    all_file << item
  end

  all_file.sort!
  b = all_file.map { |file| file.ljust(17) }
  reverse_arry = b.reverse

  line = all_file.size / 4
  
  file_arry = []
  
  reverse_arry.each_slice(line) do |a, b, c, d|
    file_arry << [a, b, c, d]
  end
    
  file_column = file_arry.transpose
  
  file_column.each do |x|
    puts x.join(' ')
  end
end

def a_option
  all_file = []

  Dir.foreach('.') do |item|
    all_file << item
    all_file.sort!
  end
  a = all_file.map { |file| file.ljust(17) }

  line = all_file.size / 4
  
  file_arry = []
  
  a.each_slice(line) do |a, b, c, d|
    file_arry << [a, b, c, d]
  end
  
  file_column = file_arry.transpose
  
  file_column.each do |x|
    puts x.join(' ')
  end
end

def l_option
  all_file = []
  
  Dir.glob('*') do |item|
    all_file << item
  end

  files = all_file.sort!

  block_arry = []
  files.each do |files|
    fs = File::Stat.new(files)
    block_arry << fs.blocks
  end
  block = block_arry.sum
  puts "total #{block}"

  permmission = []
  hard_link = []
  owner = []
  group = []
  bytes = []
  time = []
  file_name = []

  files.each do |file|    
    fs = File::Stat.new(file)
    permmission << fs.mode
    hard_link << fs.nlink
    owner << fs.uid
    group << fs.gid
    bytes << fs.size
    time << fs.atime
    file_name << file
  end

  detail = []
  a = []

  permmission.each do |symbol|
    string_symbol = symbol.to_s(8).rjust(6,'0')
    if string_symbol[0..1] == '04'
      a << 'd'
    elsif string_symbol[0..1] == '10'
      a << '-'
    elsif string_symbol[0..1] == '12'
      a << '|'
    end

    if string_symbol[2] == '1'
      a << 'x'
    elsif string_symbol[2] == '2'
      a << 'w'
    elsif string_symbol[2] == '4'
      a << 'r'
    else
      a << nil
    end

    if string_symbol[3] == '0'
      a << '---'
    elsif string_symbol[3] == '1'
      a << '--x'
    elsif string_symbol[3] == '2'
      a << '-w-'
    elsif string_symbol[3] == '3'
      a << '-wx'
    elsif string_symbol[3] == '4'
      a << 'r--'
    elsif string_symbol[3] == '5'
      a << 'r-x'
    elsif string_symbol[3] == '6'
      a << 'rw-'
    elsif string_symbol[3] == '7'
      a << 'rwx'
    end

    if string_symbol[4] == '0'
      a << '---'
    elsif string_symbol[4] == '1'
      a << '--x'
    elsif string_symbol[4] == '2'
      a << '-w-'
    elsif string_symbol[4] == '3'
      a << '-wx'
    elsif string_symbol[4] == '4'
      a << 'r--'
    elsif string_symbol[4] == '5'
      a << 'r-x'
    elsif string_symbol[4] == '6'
      a << 'rw-'
    elsif string_symbol[4] == '7'
      a << 'rwx'
    end

    if string_symbol[5] == '0'
      a << '---'
    elsif string_symbol[5] == '1'
      a << '--x'
    elsif string_symbol[5] == '2'
      a << '-w-'
    elsif string_symbol[5] == '3'
      a << '-wx'
    elsif string_symbol[5] == '4'
      a << 'r--'
    elsif string_symbol[5] == '5'
      a << 'r-x'
    elsif string_symbol[5] == '6'
      a << 'rw-'
    elsif string_symbol[5] == '7'
      a << 'rwx'
    end
  end

  @permmission_arry = []
  a.each_slice(5) do |arry|
    @permmission_arry << arry.compact.join.ljust(12,' ')
  end

  #p @permmission_arry#=>["drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "drwxr-xr-x", "-rw-r--r--", "-rw-r--r--", "drwxr-xr-x"]
  detail << @permmission_arry
  
  @b = []
  hard_link.each do |link|
    @b << link.to_s.rjust(2, ' ')
  end

  #p @b#=>[4, 5, 3, 4, 3, 3, 3, 3, 3, 1, 1, 15]
  detail << @b

  @c = []
  owner.each do |id|
    @c << Etc.getpwuid(id).name.ljust(15, ' ')
  end

  #p @c#=>["takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka", "takashimaayaka"]
  detail << @c

  @d = []
  group.each do |id|
    @d << Etc.getgrgid(id).name
  end
  detail << @d

  @e = []
  bytes.each do |byte|
    @e << byte.to_s.rjust(4, ' ')
  end
  detail << @e

  @f = []
  time.each do |time|
    year = time.year
    month = time.month
    date = time.day
    file_maked_day = Date.new(year,month, date)
    half_years_ago = Date.today.prev_month(6)

    if file_maked_day <= half_years_ago
      @f << time.strftime('%-m %e %Y')
    else
      @f << time.strftime('%-m %e %H:%M')
    end
  end
  detail << @f

  @g = []
  file_name.each do |name|
    @g << name
  end
  detail << @g

  detail_arry = detail.transpose

  detail_arry.each do |x|
    puts x.join(' ')
  end

end


if params == { 'a' => false, 'l' => false, 'r' => true }
  r_option
elsif params == { 'a' => true, 'l' => false, 'r' => false }
  a_option
elsif params == { 'a' => false, 'l' => true, 'r' => false }
  l_option
else
  ls_command
end
