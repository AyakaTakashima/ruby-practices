#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

COLUMN_COUNT = 3
def calc_row_count(files)
  if files.size > COLUMN_COUNT
    (files.size.to_f / COLUMN_COUNT).ceil
  else
    1
  end
end

def ls_command(files)
  padded_files = files.map { |file| file.ljust(17) }

  row_count = calc_row_count(files)

  file_table = []
  # transposeでエラーを起こさないよう、nilを入れるためにa, b, cへ一つずつ渡しています
  padded_files.each_slice(row_count) do |a, b, c|
    file_table << [a, b, c]
  end

  file_table.transpose.each do |row_files|
    puts row_files.join(' ')
  end
end

def l_option_main(files)
  block = files.sum do |file|
    fs = File::Stat.new(file)
    fs.blocks
  end
  puts "total #{block}"

  file_table = get_data(files)

  file_table.transpose.each do |row_files|
    puts row_files.join(' ')
  end
end

def file_type(permission_digit)
  case permission_digit[0..1]
  when '04'
    'd'
  when '10'
    '-'
  else
    '|'
  end
end

def special_permission(permission_digit)
  special_permission_hash = {
    '1' => 'x',
    '2' => 'w',
    '4' => 'r'
  }
  special_permission_hash[permission_digit[2]]
end

def build_permission(char)
  case char
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

def buld_file_details(files)
  files.map do |file|
    fs = File::Stat.new(file)
    file_detail = {}
    file_detail[:permissions] = fs.mode
    file_detail[:hard_links] = fs.nlink
    file_detail[:owners] = fs.uid
    file_detail[:groups] = fs.gid
    file_detail[:bytes] = fs.size
    file_detail[:times] = fs.atime
    file_detail[:names] = file
    file_detail
  end
end

def permission_data(file_details)
  permission_data_array = []

  file_details.each do |mode|
    permission_digit = mode[:permissions].to_s(8).rjust(6, '0')
    data_array = []
    data_array << file_type(permission_digit)
    data_array << special_permission(permission_digit)
    data_array << build_permission(permission_digit[3])
    data_array << build_permission(permission_digit[4])
    data_array << build_permission(permission_digit[5])
    permission_data_array << data_array
  end
  permission_array = []
  permission_data_array.each do |data_array|
    permission_array << "#{data_array.compact.join}  "
  end

  [permission_array]
end

def from_link_to_group_data(file_details, permission_details)
  number_of_link = []
  file_details.each do |number|
    number_of_link << number[:hard_links].to_s.rjust(2, ' ')
  end
  permission_details << number_of_link

  owner_names = []
  file_details.each do |id|
    owner_names << Etc.getpwuid(id[:owners]).name.ljust(15, ' ')
  end
  permission_details << owner_names

  group_names = []
  file_details.each do |id|
    group_names << Etc.getgrgid(id[:groups]).name
  end
  permission_details << group_names
end

def from_bytes_to_time_data(file_details, link_to_group_details)
  bytes_array = []
  file_details.each do |number|
    bytes_array << number[:bytes].to_s.rjust(4, ' ')
  end
  link_to_group_details << bytes_array

  time_array = []
  file_details.each do |time|
    year = time[:times].year
    month = time[:times].month
    date = time[:times].day
    file_maked_day = Date.new(year, month, date)
    half_years_ago = Date.today.prev_month(6)

    time_array << if file_maked_day <= half_years_ago
                    time[:times].strftime('%-m %e %Y')
                  else
                    time[:times].strftime('%-m %e %H:%M')
                  end
  end
  link_to_group_details << time_array
end

def file_name_data(file_details, bytes_to_time_details)
  file_names_array = []
  file_details.each do |name|
    file_names_array << name[:names]
  end

  bytes_to_time_details << file_names_array
end

def get_data(files)
  file_details = buld_file_details(files)
  permission_details = permission_data(file_details)
  link_to_group_details = from_link_to_group_data(file_details, permission_details)
  bytes_to_time_details = from_bytes_to_time_data(file_details, link_to_group_details)
  file_name_data(file_details, bytes_to_time_details)
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
