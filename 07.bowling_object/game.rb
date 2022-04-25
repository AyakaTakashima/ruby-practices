# frozen_string_literal: true

require './frame'

class Game
  def initialize(score_numbers)
    @score_numbers = score_numbers
  end

  attr_reader :score_numbers

  def build_frame
    shots = []
    frame_arry = []
    score_numbers.each do |score|
      shots << score
      next if frame_arry.count >= 9

      if strike?(shots[0]) && (frame_arry.count < 9)
        frame_arry << Frame.new(shots)
        shots = []
      elsif shots.count == 2
        frame_arry << Frame.new(shots)
        shots = []
      end
    end
    frame_arry << Frame.new(shots)

    frame_arry
  end

  def strike?(score)
    score == 10
  end
end
