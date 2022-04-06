#!/usr/bin/env ruby
# frozen_string_literal: true

class Game
  def initialize(frames)
    @frames = frames
  end

  def score_calculate
    @frames.each.with_index.sum do |frame, i|
      if i == 9
        frame.sum
      elsif frame[0] == 10
        frame_index = i
        strike(frame_index)
      elsif frame.sum == 10
        frame_index = i
        spare(frame_index)
      else
        frame.sum
      end
    end
  end

  def strike(frame_index)
    point = @frames[frame_index].sum
    next_index = frame_index + 1
    special_point = if (@frames[next_index][0] == 10) && (frame_index < 8)
                      @frames[next_index][0] + @frames[next_index + 1][0]
                    else
                      @frames[next_index][0] + @frames[next_index][1]
                    end
    point + special_point
  end

  def spare(frame_index)
    next_index = frame_index + 1
    point = @frames[frame_index].sum
    special_point = @frames[next_index][0]
    point + special_point
  end
end
