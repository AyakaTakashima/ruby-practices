# frozen_string_literal: true

require './file_info'

class List
  def initialize(files)
    @files = files
  end

  def display_with_details
    block = @files.sum do |file|
      File::Stat.new(file).blocks
    end
    puts "total #{block}"
  
    file_info = FileInfo.new(@files)
    file_table = file_info.build
  
    file_table.each do |row|
      puts row.join(' ')
    end
  end

  COLUMN_COUNT = 3
  def display_files
    padded_files = @files.map { |file| file.ljust(17) }
  
    row_count = (@files.size.to_f / COLUMN_COUNT).ceil
  
    file_table = []
    # transposeでエラーを起こさないよう、nilを入れるためにa, b, cへ一つずつ渡しています
    padded_files.each_slice(row_count) do |a, b, c|
      file_table << [a, b, c]
    end
  
    file_table.transpose.each do |row_files|
      puts row_files.join(' ')
    end
  end
end