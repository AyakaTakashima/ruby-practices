#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')

  if ARGV[0].nil?
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
    number_of_rows: rows.size,
    number_of_words: words_count_array.sum,
    bytes: bytes_count_array.sum
  }
  padded_result = create_padded_result(option, word_count_info)

  puts padded_result.join(' ')
end

def count_word_of_argv(option)
  count_info_list = build_count_info_list

  total_number_of_words = 0
  total_number_of_rows = 0
  total_bytes = 0

  count_info_list.map do |data_in_hash|
    total_number_of_rows += data_in_hash[:number_of_rows]
    total_number_of_words += data_in_hash[:number_of_words]
    total_bytes += data_in_hash[:bytes]
  end
  total_hash = {
    number_of_rows: total_number_of_rows,
    number_of_words: total_number_of_words,
    bytes: total_bytes,
    title: 'total'
  }

  count_info_list << total_hash

  padded_result = create_padded_result(option, count_info_list)
  padded_result.each do |result_array|
    puts result_array.join(' ')
  end
end

def build_count_info_list
  ret = []
  ARGV.each do |file_path|
    if File.exist?(file_path)
      ret << count_file_info(file_path)
      count_file_info(file_path)
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
    count_info[:number_of_words] = words.size
    count_info[:number_of_rows] = text.count("\n")
    count_info[:bytes] = FileTest.size(file)
    count_info[:title] = file
  end
  count_info
end

def create_padded_result(option, count_info_list)
  count_info_list.map do |count_info_hash|
    each_file_count_info = []
    each_file_count_info << count_info_hash[:number_of_rows].to_s.rjust(8)
    unless option['l']
      each_file_count_info << count_info_hash[:number_of_words].to_s.rjust(7)
      each_file_count_info << count_info_hash[:bytes].to_s.rjust(7)
    end
    each_file_count_info << count_info_hash[:title] if ARGV
    each_file_count_info
  end
end

main
