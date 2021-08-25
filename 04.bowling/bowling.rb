#! /usr/bin/env ruby

# frozen_string_literal: true

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(',')
score_array = score_x_array.map { |x| x == 'X' ? '10' : x }
score_integer_array = score_array.map(&:to_i)
@score_integer_array = score_integer_array

@frame_arry = []

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
  if (a == 10) && (b == 10)
    score = [a, 0]
    @frame_arry << score
    if b == 10
      score = [b, 0]
      @frame_arry << score
    end
  elsif	a == 10
    b = 0
    score = [a, b]
    score_integer_array.insert(i, 0)
    @frame_arry << score
  else
    score = [a, b]
    @frame_arry << score
  end
end

@frame_arry[10..12].each do |arry|
  arry.nil?
  frame = arry.compact
  @frame_arry[9] << frame[0]
end

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(',')
score_array = score_x_array.map { |x| x == 'X' ? '10' : x }
score_integer_array = score_array.map(&:to_i)
@score_integer_array = score_integer_array

frame_hash_in_arry = []
@frame_hash_in_arry = frame_hash_in_arry

point = []

def strike(this_frame)
  point = @frame_arry[this_frame].sum
  next_frame = this_frame + 1
  if @frame_arry[next_frame].nil?
    point
  elsif @frame_arry[next_frame][0] == 10
    special_point = @frame_arry[next_frame][0] + @frame_arry[next_frame + 1][0]
    point + special_point
  else
    special_point = @frame_arry[next_frame][0] + @frame_arry[next_frame][1]
    point + special_point
  end
end

def spare(this_frame)
  next_frame = this_frame + 1
  point = @frame_arry[this_frame].sum
  special_point = @frame_arry[next_frame][0]
  point + special_point
end

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
  if i == 10 && a == 10
    score_integer_array[-3..].each_slice(3) do |x, y, z|
      point << [x, y, z].sum
    end
  elsif i == 10
    point << @frame_arry[9].sum
  elsif i > 10
    break
  elsif	a == 10
    @score_integer_array.insert(i, 0)
    this_frame = i - 1
    point << strike(this_frame)
  elsif (i < 10) && (a < 10) && (a + b == 10)
    this_frame = i - 1
    point << spare(this_frame)
  else
    point << [a, b].sum
  end
end

p point.sum
