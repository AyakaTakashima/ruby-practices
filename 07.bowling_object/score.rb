# frozen_string_literal: true
require './frame'

class Score
  def initialize(frames)
    @frames = frames
  end

  def frames
    @frames
  end

  def score_calculate
    frames.each.with_index.sum do |frame, i|
      bonus_points = if i == 9
                       0
                     elsif frame.strike?
                       next_frame = frames[i + 1]
                       next_next_frame = frames[i + 2]
                       frame.strike_score(next_frame, next_next_frame, i)
                     elsif frame.spare?
                       next_frame = frames[i + 1]
                       frame.spare_score(next_frame)
                     else
                        0
                     end
      bonus_points + frame.normal_score
    end
  end
end
