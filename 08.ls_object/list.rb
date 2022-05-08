# frozen_string_literal: true

require_relative 'file_info'

class List
  COLUMN_COUNT = 3

  def initialize(files)
    @files = files
  end

  def display_with_details
    file_info = FileInfo.new(@files)
    blocks = file_info.each_block
    puts "total #{blocks.sum}"

    file_table = file_info.build

    file_table.each do |row|
      puts row.join(' ')
    end
  end

  def display_files
    file_info = FileInfo.new(@files)
    padding_spaces = file_info.longest_name_length
    padded_files = @files.map { |file| file.ljust(padding_spaces) }

    row_count = (@files.size.to_f / COLUMN_COUNT).ceil

    file_table = []
    padded_files.each_slice(row_count) do |padded_file|
      file_table << padded_file
    end

    if file_table[0].length > file_table.last.length
      deference = file_table[0].length - file_table.last.length
      deference.times do |_n|
        file_table.last << nil
      end
    end

    file_table.transpose.each do |row_files|
      puts row_files.join(' ')
    end
  end
end
