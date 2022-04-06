#!/usr/bin/env ruby
# frozen_string_literal: true

class Frame
  def initialize(all_shots)
    @all_shots = all_shots
  end

  def build_frame
    shots = []
    frame_arry = []
    @all_shots.each do |score|
      shots << score
      if strike?(shots[0]) && (frame_arry.count < 9)
        frame_arry << shots
        shots = []
      elsif (frame_arry.count == 10) && !shots.empty?
        frame_arry[9].concat shots
      elsif shots.count == 2
        frame_arry << shots
        shots = []
      end
    end
    frame_arry
  end

  def strike?(score)
    score == 10
  end
end
