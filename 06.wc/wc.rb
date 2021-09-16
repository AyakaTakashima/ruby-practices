#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  option =
    if params['l']
      'l'
    else
      'nil'
    end

  if ARGV[0].nil?
    count_word(option)
  else
    count_word_of_argv(option)
  end
end

def count_word(option)
  input = readlines
  words_count_array = []
  bytes_count_array = []
  results = []

  input.each.with_index(1) do |each_row, i|
    each_row.chomp!
    words_count_array << each_row.split(' ').size
    bytes_count_array << "#{each_row}\n".bytesize

    word_count_info = {}
    word_count_info[:number_of_rows] = i
    word_count_info[:number_of_words] = words_count_array.sum
    word_count_info[:bytes] = bytes_count_array.sum
    results = build_result_array(word_count_info, option)
  end

  puts results.join(' ')
end

def build_result_array(word_count_info, option)
  results = []
  results << word_count_info[:number_of_rows].to_s.rjust(8)
  if option == 'nil'
    results << word_count_info[:number_of_words].to_s.rjust(7)
    results << word_count_info[:bytes].to_s.rjust(7)
  end
  results
end

def count_word_of_argv(option)
  lines_array, words_array, bytes_array, item_array = build_array

  if ARGV.size > 1
    lines_array << lines_array.sum
    if option == 'nil'
      words_array << words_array.sum
      bytes_array << bytes_array.sum
    end
    item_array << 'total'
  end
  check_option = option
  padded_result = create_padded_result(check_option, lines_array, words_array, bytes_array, item_array)

  result_array = padded_result.transpose
  result_array.each do |array|
    puts array.join(' ')
  end
end

def build_array
  lines_array = []
  words_array = []
  bytes_array = []
  item_array = []

  ARGV.each do |word|
    if File.exist?(word)
      Dir.glob(word) do |item|
        count_info = count_file_info(item)
        lines_array << count_info[:number_of_rows]
        words_array << count_info[:number_of_words]
        bytes_array << count_info[:bytes]
        item_array << count_info[:file_name]
      end
    else
      puts "wc: #{word}: open: No such file or directory"
    end
  end
  [lines_array, words_array, bytes_array, item_array]
end

def count_file_info(file)
  if FileTest.directory?(file)
    puts "wc: #{file}: read: Is a directory"
  else
    words = []
    File.new(file).each do |each_row|
      row_built_words = each_row.split(' ')
      row_built_words.each { |word| words << word }
    end

    count_info = {}
    count_info[:number_of_words] = words.size
    count_info[:number_of_rows] = File.open(file).read.count("\n")
    count_info[:bytes] = FileTest.size(file)
    count_info[:file_name] = file
  end
  count_info
end

def create_padded_result(check_option, lines_array, words_array, bytes_array, item_array)
  result = []
  result << lines_array.map { |file| file.to_s.rjust(8) }
  unless check_option == 'l'
    result << words_array.map { |file| file.to_s.rjust(7) }
    result << bytes_array.map { |file| file.to_s.rjust(7) }
  end
  result << item_array
end

main
