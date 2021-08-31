#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def file_info
  all_file = []
  Dir.glob('*') do |item|
    all_file << item
    all_file.sort!
  end
  all_file
end

def file_info_include_invisible_file
  all_file = []
  Dir.foreach('.') do |item|
    all_file << item
    all_file.sort!
  end
  all_file
end

def ls_command(option)
  all_file =
    if option[1] == 'a'
      file_info_include_invisible_file
    else
      file_info
    end

  padding_all_file = all_file.map { |file| file.ljust(17) }

  padding_all_file.reverse! if option[0] == 'r'

  line = all_file.size / 4
  file_array = []
  padding_all_file.each_slice(line) do |a, b, c, d|
    file_array << [a, b, c, d]
  end

  file_column = file_array.transpose
  file_column.each do |x|
    puts x.join(' ')
  end
end

def l_option_main(option)
  all_file =
    if option[1] == 'a'
      file_info_include_invisible_file
    else
      file_info
    end

  all_file.reverse! if option[0] == 'r'

  block_array = []
  all_file.each do |file|
    fs = File::Stat.new(file)
    block_array << fs.blocks
  end
  block = block_array.sum
  puts "total #{block}"

  file_array = data_get(all_file)

  file_column = file_array.transpose
  file_column.each do |x|
    puts x.join(' ')
  end
end

def file_type(string_symbol)
  case string_symbol[0..1]
  when '04'
    'd'
  when '10'
    '-'
  else
    '|'
  end
end

def special_permission(string_symbol)
  special_permission_hash = {
    '1' => 'x',
    '2' => 'w',
    '4' => 'r'
  }
  special_permission_hash[string_symbol[2]]
end

def owner_permission(string_symbol)
  case string_symbol[3]
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

def group_permission(string_symbol)
  case string_symbol[4]
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

def other_user_permission(string_symbol)
  case string_symbol[5]
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

def detail_data_get(all_file)
  permission = []
  hard_link = []
  owner = []
  group = []
  bytes = []
  time = []
  file_name = []

  all_file.each do |file|
    fs = File::Stat.new(file)
    permission << fs.mode
    hard_link << fs.nlink
    owner << fs.uid
    group << fs.gid
    bytes << fs.size
    time << fs.atime
    file_name << file
  end
  [permission, hard_link, owner, group, bytes, time, file_name]
end

def from_link_to_group_data(hard_link, owner, group, permission_detail)
  number_of_link = []
  hard_link.each do |link|
    number_of_link << link.to_s.rjust(2, ' ')
  end
  permission_detail << number_of_link

  owner_names = []
  owner.each do |id|
    owner_names << Etc.getpwuid(id).name.ljust(15, ' ')
  end
  permission_detail << owner_names

  group_names = []
  group.each do |id|
    group_names << Etc.getgrgid(id).name
  end
  permission_detail << group_names
end

def permission_data(permission)
  permission_data_array = []

  permission.each do |symbol|
    string_symbol = symbol.to_s(8).rjust(6, '0')
    permission_data_array << file_type(string_symbol)
    permission_data_array << special_permission(string_symbol)
    permission_data_array << owner_permission(string_symbol)
    permission_data_array << group_permission(string_symbol)
    permission_data_array << other_user_permission(string_symbol)
  end

  permission_array = []
  permission_data_array.each_slice(5) do |array|
    permission_array << array.compact.join.ljust(12, ' ')
  end

  permission_detail = []
  permission_detail << permission_array
end

def from_bytes_to_time_data(bytes, time, link_to_group_detail)
  bytes_array = []
  bytes.each do |byte|
    bytes_array << byte.to_s.rjust(4, ' ')
  end
  link_to_group_detail << bytes_array

  time_array = []
  time.each do |t|
    year = t.year
    month = t.month
    date = t.day
    file_maked_day = Date.new(year, month, date)
    half_years_ago = Date.today.prev_month(6)

    time_array << if file_maked_day <= half_years_ago
                    t.strftime('%-m %e %Y')
                  else
                    t.strftime('%-m %e %H:%M')
                  end
  end
  link_to_group_detail << time_array
end

def file_name_data(file_name, bytes_to_time_detail)
  file_names = []
  bytes_to_time_detail << file_name.each do |name|
    file_names << name
  end

  bytes_to_time_detail
end

def data_get(all_file)
  permission, hard_link, owner, group, bytes, time, file_name = detail_data_get(all_file)
  permission_detail = permission_data(permission)
  link_to_group_detail = from_link_to_group_data(hard_link, owner, group, permission_detail)
  bytes_to_time_detail = from_bytes_to_time_data(bytes, time, link_to_group_detail)
  file_name_data(file_name, bytes_to_time_detail)
end

params = ARGV.getopts('alr')

option = []

option <<
  if params['r']
    'r'
  else
    'nil'
  end

option <<
  if params['a']
    'a'
  else
    'nil'
  end

if params['l']
  l_option_main(option)
else
  ls_command(option)
end
