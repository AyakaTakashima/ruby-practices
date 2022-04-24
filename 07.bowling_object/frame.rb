# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots[0] == 10
  end

  def spare?
    @shots.sum == 10
  end

  def normal_score
    @shots.sum
  end

  def strike_score(next_frame, next_next_frame, frame_index)
    point = self.normal_score
    special_point = if next_frame.strike? && (frame_index < 8)
                      next_frame.shots[0] + next_next_frame.shots[0]
                    else
                      next_frame.shots[0] + next_frame.shots[1]
                    end
  end

  def spare_score

  end
end