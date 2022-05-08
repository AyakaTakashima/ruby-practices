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
    paddings = build_paddings

    file_details.map do |file_detail|
      detail = Detail.new(file_detail)
      [
        detail.build_permission,
        file_detail[:nlink].to_s.rjust(paddings[0], ' '),
        Etc.getpwuid(file_detail[:uid]).name.ljust(paddings[1], ' '),
        Etc.getgrgid(file_detail[:gid]).name,
        file_detail[:size].to_s.rjust(paddings[2], ' '),
        detail.build_updated_at,
        file_detail[:file_name]
      ]
    end
  end

  def build_paddings
    file_details = build_file_details

    nlink_lengths = []
    uid_lengths = []
    size_lengths = []
    file_details.map do |file_detail|
      nlink_lengths << file_detail[:nlink].to_s.length
      uid_lengths << Etc.getpwuid(file_detail[:uid]).name.length
      size_lengths << file_detail[:size].to_s.length
    end
    [
      nlink_lengths.max + 1,
      uid_lengths.max + 1,
      size_lengths.max + 1
    ]
  end

  def build_file_details
    @files.map do |file|
      fs = File::Stat.new(file)
      {
        mode: fs.mode,
        nlink: fs.nlink,
        uid: fs.uid,
        gid: fs.gid,
        size: fs.size,
        atime: fs.atime,
        file_name: file
      }
    end
  end
end
