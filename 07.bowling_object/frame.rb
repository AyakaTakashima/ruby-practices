# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def shots
    @shots
  end

  def strike?
    shots[0] == 10
  end

  def spare?
    shots.sum == 10
  end

  def normal_score
    shots.sum
  end

  def strike_score(next_frame, next_next_frame, frame_index)
    if next_frame.strike? && (frame_index < 8)
      next_frame.shots[0] + next_next_frame.shots[0]
    else
      next_frame.shots[0] + next_frame.shots[1]
    end
  end

  def spare_score(next_frame)
    next_frame.shots[0]
  end
end