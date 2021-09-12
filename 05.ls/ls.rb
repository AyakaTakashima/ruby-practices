#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def main
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
end

COLUMN_COUNT = 3
def calc_row_count(files)
  if files.size > COLUMN_COUNT
    (files.size.to_f / COLUMN_COUNT).ceil if files.size > COLUMN_COUNT
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
    File::Stat.new(file).blocks
  end
  puts "total #{block}"

  file_table = get_data(files)

  file_table.each do |row|
    puts row.join(' ')
  end
end

def file_type(permission_digit)
  case permission_digit[0..1]
  when '04'
    'd'
  when '10'
    '-'
  else
    'l'
  end
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

def build_file_details(files)
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

def get_permission_data(file_detail)
  permission_digit = file_detail[:permissions].to_s(8).rjust(6, '0')
  data_array = []
  data_array << file_type(permission_digit)
  data_array << build_permission(permission_digit[3])
  data_array << build_permission(permission_digit[4])
  data_array << build_permission(permission_digit[5])

  data_array.join
end

def get_owner_and_group_names(file_detail)
  permission_details = []
  owner_names = Etc.getpwuid(file_detail[:owners]).name.ljust(15, ' ')
  permission_details << owner_names

  group_names = Etc.getgrgid(file_detail[:groups]).name
  permission_details << group_names
end

def get_time_data(file_detail)
  year = file_detail[:times].year
  month = file_detail[:times].month
  date = file_detail[:times].day
  file_created_day = Date.new(year, month, date)
  half_years_ago = Date.today.prev_month(6)

  month = file_detail[:times].strftime('%-m').rjust(2, ' ')
  date = file_detail[:times].strftime('%e').rjust(2, ' ')

  if file_created_day <= half_years_ago
    year = file_detail[:times].strftime('%Y').rjust(5, ' ')
    [month, date, year]
  else
    time = file_detail[:times].strftime('%H:%M')
    [month, date, time]
  end
end

def get_data(files)
  file_details = build_file_details(files)

  all_data = []
  file_details.each do |file_detail|
    row_data = []
    row_data << get_permission_data(file_detail)
    row_data << file_detail[:hard_links].to_s.rjust(3, ' ')
    row_data << get_owner_and_group_names(file_detail)
    row_data << file_detail[:bytes].to_s.rjust(4, ' ')
    row_data << get_time_data(file_detail)
    row_data << file_detail[:names]

    all_data << row_data
  end
  all_data
end

main
