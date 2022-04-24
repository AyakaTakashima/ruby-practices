#!/usr/bin/env ruby
# frozen_string_literal: true

require './shot'
require './game'
require './score'

def calculate_score(pinfall_text)
  score_numbers = pinfall_text[0].split(',').map do |mark|
    numbers = Shot.new(mark)
    numbers.score
  end

  game = Game.new(score_numbers)
  frames = game.build_frame
  score = Score.new(frames)
  p score.score_calculate
end

calculate_score(ARGV) if __FILE__ == $PROGRAM_NAME
