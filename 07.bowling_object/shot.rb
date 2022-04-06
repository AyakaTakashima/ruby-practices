#!/usr/bin/env ruby
# frozen_string_literal: true

class Shot
  def initialize(shots)
    @shots = shots
  end

  def score
    @score = @shots[0].split(',').map { |mark| mark == 'X' ? 10 : mark.to_i }
  end
end
