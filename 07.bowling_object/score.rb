#!/usr/bin/env ruby
# frozen_string_literal: true

class Score
  def initialize(frame_arry)
    @frame_arry = frame_arry
  end

  def score_calculate
    @frame_arry.each.with_index.sum do |frame, i|
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
    point = @frame_arry[frame_index].sum
    next_index = frame_index + 1
    special_point = if (@frame_arry[next_index][0] == 10) && (frame_index < 8)
                      @frame_arry[next_index][0] + @frame_arry[next_index + 1][0]
                    else
                      @frame_arry[next_index][0] + @frame_arry[next_index][1]
                    end
    point + special_point
  end

  def spare(frame_index)
    next_index = frame_index + 1
    point = @frame_arry[frame_index].sum
    special_point = @frame_arry[next_index][0]
    point + special_point
  end
end
