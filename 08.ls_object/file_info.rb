# frozen_string_literal: true

require_relative 'detail'
require 'etc'

class FileInfo
  def initialize(files)
    @files = files
  end

  def each_block
    file_blocks = []
    @files.each do |file|
      file_blocks << File::Stat.new(file).blocks
    end
    file_blocks
  end

  def longest_name_length
    @files.map(&:length).max
  end

  def build
    file_details = build_file_details

    nlink_lengths = []
    uid_lengths = []
    size_lengths = []
    file_details.map do |file_detail|
      nlink_lengths << file_detail[:nlink].to_s.length
      uid_lengths << Etc.getpwuid(file_detail[:uid]).name.length
      size_lengths << file_detail[:size].to_s.length
    end
    nlink_padding = nlink_lengths.max + 1
    uid_padding = uid_lengths.max + 1
    size_padding = size_lengths.max + 1

    file_details.map do |file_detail|
      detail = Detail.new(file_detail)
      row_data = []
      row_data << detail.build_permission
      row_data << file_detail[:nlink].to_s.rjust(nlink_padding, ' ')
      row_data << Etc.getpwuid(file_detail[:uid]).name.ljust(uid_padding, ' ')
      row_data << Etc.getgrgid(file_detail[:gid]).name
      row_data << file_detail[:size].to_s.rjust(size_padding, ' ')
      row_data << detail.build_updated_at
      row_data << file_detail[:file_name]
      row_data
    end
  end

  def build_file_details
    @files.map do |file|
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
end
