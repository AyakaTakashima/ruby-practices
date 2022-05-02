#!/usr/bin/env ruby
# frozen_string_literal: true

require './list'

require 'optparse'

def ls
  params = ARGV.getopts('alr')

  files =
    if params['a']
      Dir.glob('*', File::FNM_DOTMATCH).sort
    else
      Dir.glob('*').sort
    end

  files.reverse! if params['r']

  if params['l']
    list = List.new(files)
    list.display_with_details
  else
    list = List.new(files)
    list.display_files
  end
end

ls