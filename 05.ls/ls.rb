#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

params = ARGV.getopts('alr')

def ls_command
  all_file = []
  Dir.glob('*') do |item|
    all_file << item
    all_file.sort!
  end
  padding_all_file = all_file.map { |file| file.ljust(17) }
  line = all_file.size / 4
  file_arry = []
  padding_all_file.each_slice(line) do |a, b, c, d|
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
    all_file.sort!
  end

  padding_all_file = all_file.map { |file| file.ljust(17) }
  reverse_arry = padding_all_file.reverse

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
  padding_all_file = all_file.map { |file| file.ljust(17) }

  line = all_file.size / 4
  file_arry = []
  padding_all_file.each_slice(line) do |a, b, c, d|
    file_arry << [a, b, c, d]
  end
  file_column = file_arry.transpose
  file_column.each do |x|
    puts x.join(' ')
  end
end

def file_type
  @a << case @string_symbol[0..1]
        when '04'
          'd'
        when '10'
          '-'
        else
          '|'
        end
end

def special_permission
  special_permission_hash = {
    '1' => 'x',
    '2' => 'w',
    '4' => 'r'
  }
  @a << special_permission_hash[@string_symbol[2]]
end

def owner_permission
  @a << case @string_symbol[3]
        when '0'
          '---'
        when '1'
          '--x'
        when '2'
          '-w-'
        when '3'
          '-wx'
        when '4'
          'r--'
        when '5'
          'r-x'
        when '6'
          'rw-'
        else
          'rwx'
        end
end

def group_permission
  @a << case @string_symbol[4]
        when '0'
          '---'
        when '1'
          '--x'
        when '2'
          '-w-'
        when '3'
          '-wx'
        when '4'
          'r--'
        when '5'
          'r-x'
        when '6'
          'rw-'
        else
          'rwx'
        end
end

def other_user_permission
  @a << case @string_symbol[5]
        when '0'
          '---'
        when '1'
          '--x'
        when '2'
          '-w-'
        when '3'
          '-wx'
        when '4'
          'r--'
        when '5'
          'r-x'
        when '6'
          'rw-'
        else
          'rwx'
        end
end

@permission = []
@hard_link = []
@owner = []
@group = []
@bytes = []
@time = []
@file_name = []

def detail_data_get
  @all_file.each do |file|
    fs = File::Stat.new(file)
    @permission << fs.mode
    @hard_link << fs.nlink
    @owner << fs.uid
    @group << fs.gid
    @bytes << fs.size
    @time << fs.atime
    @file_name << file
  end
end

def from_link_to_group_data
  @b = []
  @hard_link.each do |link|
    @b << link.to_s.rjust(2, ' ')
  end
  @detail << @b

  @c = []
  @owner.each do |id|
    @c << Etc.getpwuid(id).name.ljust(15, ' ')
  end
  @detail << @c

  @d = []
  @group.each do |id|
    @d << Etc.getgrgid(id).name
  end
  @detail << @d
end

def permission_data
  @detail = []
  @a = []

  @permission.each do |symbol|
    @string_symbol = symbol.to_s(8).rjust(6, '0')
    file_type
    special_permission
    owner_permission
    group_permission
    other_user_permission
  end

  @permission_arry = []
  @a.each_slice(5) do |arry|
    @permission_arry << arry.compact.join.ljust(12, ' ')
  end
  @detail << @permission_arry
end

def from_bytes_to_time_data
  @e = []
  @bytes.each do |byte|
    @e << byte.to_s.rjust(4, ' ')
  end
  @detail << @e

  @f = []
  @time.each do |t|
    year = t.year
    month = t.month
    date = t.day
    file_maked_day = Date.new(year, month, date)
    half_years_ago = Date.today.prev_month(6)

    @f << if file_maked_day <= half_years_ago
            t.strftime('%-m %e %Y')
          else
            t.strftime('%-m %e %H:%M')
          end
  end
  @detail << @f
end

def file_name_data
  @g = []
  @file_name.each do |name|
    @g << name
  end
  @detail << @g
end

def data_get
  detail_data_get
  permission_data
  from_link_to_group_data
  from_bytes_to_time_data
  file_name_data
end

def l_option
  @all_file = []
  Dir.glob('*') do |item|
    @all_file << item
    @all_file.sort!
  end

  block_arry = []
  @all_file.each do |file|
    fs = File::Stat.new(file)
    block_arry << fs.blocks
  end
  block = block_arry.sum
  puts "total #{block}"

  data_get

  detail_arry = @detail.transpose

  detail_arry.each do |x|
    puts x.join(' ')
  end
end

case params
when { 'a' => false, 'l' => false, 'r' => true }
  r_option
when { 'a' => true, 'l' => false, 'r' => false }
  a_option
when { 'a' => false, 'l' => true, 'r' => false }
  l_option
else
  ls_command
end
