#!/usr/bin/env ruby
# frozen_string_literal: true

require './shot'
require './frame'
require './game'

def calculate_score(pinfall_text)
  shots = Shot.new(pinfall_text)
  all_shots = shots.score
  frame = Frame.new(all_shots)
  frames = frame.build_frame
  game = Game.new(frames)
  p game.score_calculate
end

calculate_score(ARGV) if __FILE__ == $PROGRAM_NAME
