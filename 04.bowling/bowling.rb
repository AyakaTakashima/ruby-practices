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

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
  if i == 10 && a == 10
    score_integer_array[-3..].each_slice(3) do |x, y, z|
      frame = { i => [x, y, z] }
      @frame_hash_in_arry << frame
    end
  elsif i == 10
    frame = { i => @frame_arry[9] }
    @frame_hash_in_arry << frame
    break
  elsif i == 11
    break
  elsif	a == 10
    frame = { i => 'strike' }
    @frame_hash_in_arry << frame
    @score_integer_array.insert(i, 0)
  else
    frame = { i => [a, b] }
    @frame_hash_in_arry << frame
  end
end

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

@frame_hash_in_arry.select do |hash|
  @frame_hash = hash.to_h
  @frame_hash.each do |key, value|
    if value == 'strike'
      this_frame = key - 1
      point << strike(this_frame)
      break
    elsif (key < 11) && (value.sum == 10)
      this_frame = key - 1
      point << spare(this_frame)
      break
    elsif key < 10
      point << value.sum
    else
      point << value.sum
    end
  end
end

p point.sum
