#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def fixed_line(files)
  line = 3

  column = if files.size > line
             if (files.size % line) != 0
              (files.size / line) + 1
             else
              files.size / line
             end
           else files.size < line
             1
           end
end

def ls_command(files)
  padded_files = files.map { |file| file.ljust(17) }

  column = fixed_line(files)

  file_table = []
  padded_files.each_slice(column) do |a, b, c|
    file_table << [a, b, c]
  end

  file_table.transpose.each do |row_files|
    puts row_files.join(' ')
  end
end

def l_option_main(files)
  block_array = []
  files.each do |file|
    fs = File::Stat.new(file)
    block_array << fs.blocks
  end
  block = block_array.sum
  puts "total #{block}"

  file_table = data_get(files)

  file_table.transpose.each do |row_files|
    puts row_files.join(' ')
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

def detail_data_get(files)
  permissions = []
  hard_links = []
  owners = []
  groups = []
  bytes = []
  times = []
  file_names = []

  files.each do |file|
    fs = File::Stat.new(file)
    permissions << fs.mode
    hard_links << fs.nlink
    owners << fs.uid
    groups << fs.gid
    bytes << fs.size
    times << fs.atime
    file_names << file
  end
  [permissions, hard_links, owners, groups, bytes, times, file_names]
end

def from_link_to_group_data(hard_links, owners, groups, permission_details)
  number_of_link = []
  hard_links.each do |link|
    number_of_link << link.to_s.rjust(2, ' ')
  end
  permission_details << number_of_link

  owner_names = []
  owners.each do |id|
    owner_names << Etc.getpwuid(id).name.ljust(15, ' ')
  end
  permission_details << owner_names

  group_names = []
  groups.each do |id|
    group_names << Etc.getgrgid(id).name
  end
  permission_details << group_names
end

def permission_data(permissions)
  permission_data_array = []

  permissions.each do |symbol|
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

  permission_details = []
  permission_details << permission_array
end

def from_bytes_to_time_data(bytes, times, link_to_group_details)
  bytes_array = []
  bytes.each do |byte|
    bytes_array << byte.to_s.rjust(4, ' ')
  end
  link_to_group_details << bytes_array

  time_array = []
  times.each do |t|
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
  link_to_group_details << time_array
end

def file_name_data(file_names, bytes_to_time_details)
  file_names_array = []
  bytes_to_time_details << file_names.each do |name|
    file_names_array << name
  end

  bytes_to_time_details
end

def data_get(files)
  permissions, hard_links, owners, groups, bytes, times, file_names = detail_data_get(files)
  permission_details = permission_data(permissions)
  link_to_group_details = from_link_to_group_data(hard_links, owners, groups, permission_details)
  bytes_to_time_details = from_bytes_to_time_data(bytes, times, link_to_group_details)
  file_name_data(file_names, bytes_to_time_details)
end

params = ARGV.getopts('alr')

files =
if params['a']
  Dir.glob('*', File::FNM_DOTMATCH).sort
else
  Dir.glob('*').sort
end

files.reverse! if params['r']

if params['l']
  l_option_main(files)
else
  ls_command(files)
end
