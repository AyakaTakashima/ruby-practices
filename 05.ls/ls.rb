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
    display_file_list_with_details(files)
  else
    display_file_list(files)
  end
end

def display_file_list_with_details(files)
  block = files.sum do |file|
    File::Stat.new(file).blocks
  end
  puts "total #{block}"

  file_table = build_file_info(files)

  file_table.each do |row|
    puts row.join(' ')
  end
end

def build_file_info(files)
  file_details = build_file_details(files)

  file_details.map do |file_detail|
    row_data = []
    row_data << build_permission_info(file_detail)
    row_data << file_detail[:nlink].to_s.rjust(3, ' ')
    row_data << Etc.getpwuid(file_detail[:uid]).name.ljust(15, ' ')
    row_data << Etc.getgrgid(file_detail[:gid]).name
    row_data << file_detail[:size].to_s.rjust(4, ' ')
    row_data << build_time_info(file_detail)
    row_data << file_detail[:file_name]
    row_data
  end
end

def build_file_details(files)
  files.map do |file|
    fs = File::Stat.new(file)
    file_detail = {}
    file_detail[:mode] = fs.mode
    file_detail[:nlink] = fs.nlink
    file_detail[:uid] = fs.uid
    file_detail[:gid] = fs.gid
    file_detail[:size] = fs.size
    file_detail[:atime] = fs.atime
    file_detail[:file_name] = file
    file_detail
  end
end

def build_permission_info(file_detail)
  permission_digit = file_detail[:mode].to_s(8).rjust(6, '0')
  [
  FILE_TYPE_TABLE[permission_digit[0..1]],
  PERMISSION_TABLE[permission_digit[3]],
  PERMISSION_TABLE[permission_digit[4]],
  PERMISSION_TABLE[permission_digit[5]]
  ].join
end

FILE_TYPE_TABLE = {
  '04' => 'd',
  '10' => '-',
  '12' => 'l'
}

PERMISSION_TABLE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx',
}

def build_time_info(file_detail)
  file_creation_date = file_detail[:atime].to_date
  half_years_ago = Date.today.prev_month(6)

  if file_creation_date <= half_years_ago
    file_detail[:atime].strftime('%_m %_e  %Y')
  else
    file_detail[:atime].strftime('%_m %_e %H:%M')
  end
end

COLUMN_COUNT = 3
def display_file_list(files)
  padded_files = files.map { |file| file.ljust(17) }

  row_count = (files.size.to_f / COLUMN_COUNT).ceil

  file_table = []
  # transposeでエラーを起こさないよう、nilを入れるためにa, b, cへ一つずつ渡しています
  padded_files.each_slice(row_count) do |a, b, c|
    file_table << [a, b, c]
  end

  file_table.transpose.each do |row_files|
    puts row_files.join(' ')
  end
end

main
