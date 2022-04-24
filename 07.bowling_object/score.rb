# frozen_string_literal: true
require './frame'

class Score
  def initialize(frames)
    @frames = frames
  end

  def score_calculate
    @frames.each.with_index.sum do |frame, i|
      if i == 9
        frame.normal_score
      elsif frame.strike?
        next_frame = @frames[i + 1]
        next_next_frame = @frames[i + 2]
        frame.strike_score(next_frame, next_next_frame, i) + frame.normal_score
      elsif frame.spare?
        frame_index = i
        spare(frame_index)
      else
        frame.normal_score
      end
    end
  end

  def spare(frame_index)
    next_index = frame_index + 1
    point = @frames[frame_index].normal_score
    special_point = @frames[next_index].shots[0]
    point + special_point
  end
end
