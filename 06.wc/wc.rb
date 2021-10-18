#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  option = ARGV.getopts('l')
  file_paths = ARGV

  if file_paths.empty?
    count_word(option)
  else
    count_word_of_argv(option, file_paths)
  end
end

def count_word(option)
  text = readlines.join
  file = nil
  word_count_info = [count_file_info(file, text)]

  padded_result = create_padded_result(option, word_count_info)

  puts padded_result.join(' ')
end

def count_word_of_argv(option, file_paths)
  count_info_list = build_count_info_list(file_paths)
  count_info_list << build_total_hash(count_info_list) if file_paths.size > 1
  padded_result = create_padded_result(option, count_info_list)
  padded_result.each { |result_array| puts result_array.join(' ') }
end

def build_total_hash(count_info_list)
  total_hash = { rows_count: 0, words_count: 0, bytes: 0 }

  count_info_list.map do |data_in_hash|
    total_hash[:rows_count] += data_in_hash[:rows_count]
    total_hash[:words_count] += data_in_hash[:words_count]
    total_hash[:bytes] += data_in_hash[:bytes]
  end
  total_hash[:file_name] = 'total'

  total_hash
end

def build_count_info_list(file_paths)
  ret = []
  file_paths.each do |file_path|
    if File.exist?(file_path)
      if FileTest.directory?(file_path)
        puts "wc: #{file_path}: read: Is a directory"
      else
        text = File.read(file_path)
        ret << count_file_info(file_path, text)
      end
    else
      puts "wc: #{file_path}: open: No such file or directory"
    end
  end
  ret
end

def count_file_info(file, text)
  words = text.each_line.flat_map do |row|
    row.split(' ')
  end

  {
    words_count: words.size,
    rows_count: text.count("\n"),
    bytes: text.size,
    file_name: file
  }
end

def create_padded_result(option, count_info_list)
  count_info_list.map do |count_info|
    each_file_count_info = []
    each_file_count_info << " #{format_value(count_info[:rows_count])}"
    unless option['l']
      each_file_count_info << format_value(count_info[:words_count])
      each_file_count_info << format_value(count_info[:bytes])
    end
    each_file_count_info << count_info[:file_name] if count_info[:file_name]
    each_file_count_info
  end
end

def format_value(value)
  value.to_s.rjust(7)
end

main
