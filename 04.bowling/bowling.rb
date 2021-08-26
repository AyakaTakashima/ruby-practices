#! /usr/bin/env ruby

# frozen_string_literal: true

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(',')
score_array = score_x_array.map { |x| x == 'X' ? '10' : x }
score_integer_array = score_array.map(&:to_i)

@frame_arry = []

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
  if (a == 10) && (b == 10)
    score = [a, 0]
    @frame_arry << score
    score = [b, 0]
    @frame_arry << score
  elsif	a == 10
    score_integer_array.insert(i, b)
    score = [a, 0]
    @frame_arry << score
  else
    score = [a, b]
    @frame_arry << score
  end
end

@frame_arry[10..11].each do |arry|
  @frame_arry[9] << arry[0]
  next if arry[1].nil?

  @frame_arry[9] << arry[1]
end

def strike(frame_index)
  point = @frame_arry[frame_index].sum
  next_index = frame_index + 1
  if @frame_arry[next_index][0] == 10
    special_point = @frame_arry[next_index][0] + @frame_arry[next_index + 1][0]
  else
    special_point = @frame_arry[next_index][0] + @frame_arry[next_index][1]
  end
  point + special_point
end

def spare(frame_index)
  next_index = frame_index + 1
  point = @frame_arry[frame_index].sum
  special_point = @frame_arry[next_index][0]
  point + special_point
end

point = @frame_arry.each.with_index(1).sum do | frame, i|
  if i == 10
    frame.sum
  elsif i > 10
    0
  elsif frame[0] == 10
    frame_index = i - 1
    strike(frame_index)
  elsif frame[0] + frame[1] == 10
    frame_index = i - 1
    spare(frame_index)
  else
    frame.sum
  end
end

p point