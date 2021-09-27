#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  file_paths = ARGV

  if file_paths.empty?
    count_word(option, file_paths)
  else
    count_word_of_argv(option, file_paths)
  end
end

def count_word(option, file_paths)
  text = readlines.join
  file = nil
  word_count_info = []
  word_count_info << count_file_info(file, text)

  padded_result = create_padded_result(option, word_count_info, file_paths)

  puts padded_result.join
end

def count_word_of_argv(option, file_paths)
  count_info_list = build_count_info_list(file_paths)

  if file_paths.size > 1
    build_total_hash(option, count_info_list)
    padded_result = create_padded_result(option, count_info_list, file_paths)
  else
    padded_result = create_padded_result(option, count_info_list, file_paths) unless count_info_list == [nil]
  end

  padded_result.each { |result_array| puts result_array.join(' ') } if padded_result
end

def build_total_hash(option, count_info_list)
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
end

def build_count_info_list(file_paths)
  ret = []
  file_paths.each do |file_path|
    if File.exist?(file_path)
      ret << check_file_or_directory(file_path)
    else
      puts "wc: #{file_path}: open: No such file or directory"
    end
  end
  ret
end

def check_file_or_directory(file)
  if FileTest.directory?(file)
    puts "wc: #{file}: read: Is a directory"
  else
    text = File.read(file)
    count_info = count_file_info(file, text)
  end
  count_info
end

def count_file_info(file, text)
  words = text.each_line.flat_map do |row|
    row.split(' ')
  end

  count_info = {}
  count_info[:words_count] = words.size
  count_info[:rows_count] = text.count("\n")
  if file
    count_info[:bytes] = FileTest.size(file)
    count_info[:title] = file
  else
    count_info[:bytes] = text.size
  end
  count_info
end

def create_padded_result(option, count_info_list, file_paths)
  count_info_list.map do |count_info_hash|
    each_file_count_info = []
    each_file_count_info << " #{count_info_hash[:rows_count].to_s.rjust(format_value)}"
    unless option['l']
      each_file_count_info << count_info_hash[:words_count].to_s.rjust(format_value)
      each_file_count_info << count_info_hash[:bytes].to_s.rjust(format_value)
    end
    each_file_count_info << count_info_hash[:title] if file_paths
    each_file_count_info
  end
end

def format_value
  7
end

main
