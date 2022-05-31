#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'list'
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

  list = List.new(files)
  if params['l']
    list.display_with_details
  else
    list.display_files
  end
end

ls
