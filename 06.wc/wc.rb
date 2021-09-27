#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')

  if ARGV.empty?#[0].nil?
    count_word(option)
  else
    count_word_of_argv(option)
  end
end

def count_word(option)
  rows = readlines
  words_count_array = []
  bytes_count_array = []

  rows.each do |row|
    row.chomp!
    words_count_array << row.split(' ').size
    bytes_count_array << "#{row}\n".bytesize
  end

  word_count_info = []
  word_count_info << {
    rows_count: rows.size,
    words_count: words_count_array.sum,
    bytes: bytes_count_array.sum
  }
  padded_result = create_padded_result(option, word_count_info)

  puts padded_result.join(' ')
end

def count_word_of_argv(option)
  count_info_list = build_count_info_list

  if ARGV.size > 1
    total_words_count = 0
    total_rows_count = 0
    total_bytes = 0
  
    count_info_list.map do |data_in_hash|
      total_rows_count += data_in_hash[:rows_count]
      total_words_count += data_in_hash[:words_count] unless option['l']
      total_bytes += data_in_hash[:bytes] unless option['l']
    end
    total_hash = {}
    total_hash[:rows_count] = total_rows_count
    total_hash[:words_count] = total_words_count unless option['l']
    total_hash[:bytes] = total_bytes unless option['l']
    total_hash[:title] = 'total'

    count_info_list << total_hash
    padded_result = create_padded_result(option, count_info_list)
  end

  padded_result.each do |result_array|
    puts result_array.join(' ')
  end unless padded_result == nil
end

def build_count_info_list
  ret = []
  ARGV.each do |file_path|
    if File.exist?(file_path)
      ret << count_file_info(file_path)
    else
      puts "wc: #{file_path}: open: No such file or directory"
    end
  end
  ret
end

def count_file_info(file)
  if FileTest.directory?(file)
    puts "wc: #{file}: read: Is a directory"
  else
    text = File.read(file)
    words = text.each_line.flat_map do |row|
      row.split(' ')
    end

    count_info = {}
    count_info[:words_count] = words.size
    count_info[:rows_count] = text.count("\n")
    count_info[:bytes] = FileTest.size(file)
    count_info[:title] = file
  end
  count_info
end

def create_padded_result(option, count_info_list)
  count_info_list.map do |count_info_hash|
    each_file_count_info = []
    each_file_count_info << count_info_hash[:rows_count].to_s.rjust(8)
    unless option['l']
      each_file_count_info << count_info_hash[:words_count].to_s.rjust(7)
      each_file_count_info << count_info_hash[:bytes].to_s.rjust(7)
    end
    each_file_count_info << count_info_hash[:title] if ARGV
    each_file_count_info
  end
end

main
