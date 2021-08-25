#! /usr/bin/env ruby

# frozen_string_literal: true

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(',')
score_array = score_x_array.map { |x| x == 'X' ? '10' : x }
score_integer_array = score_array.map(&:to_i)
@score_integer_array = score_integer_array

@flame_arry = []

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
  if (a == 10) && (b == 10)
    score = [a, 0]
    @flame_arry << score
    if b == 10
      score = [b, 0]
      @flame_arry << score
    end
  elsif	a == 10
    b = 0
    score = [a, b]
    score_integer_array.insert(i, 0)
    @flame_arry << score
  else
    score = [a, b]
    @flame_arry << score
  end
end

@flame_arry[10..12].each do |arry|
  arry.nil?
  flame = arry.compact
  @flame_arry[9] << flame[0]
end

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(',')
score_array = score_x_array.map { |x| x == 'X' ? '10' : x }
score_integer_array = score_array.map(&:to_i)
@score_integer_array = score_integer_array

flame_hash_in_arry = []
@flame_hash_in_arry = flame_hash_in_arry

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
  if i == 10 && a == 10
    score_integer_array[-3..].each_slice(3) do |x, y, z|
      flame = { i => [x, y, z] }
      @flame_hash_in_arry << flame
    end
  elsif i == 10
    flame = { i => @flame_arry[9] }
    @flame_hash_in_arry << flame
    break
  elsif i == 11
    break
  elsif	a == 10
    flame = { i => 'strike' }
    @flame_hash_in_arry << flame
    @score_integer_array.insert(i, 0)
  else
    flame = { i => [a, b] }
    @flame_hash_in_arry << flame
  end
end

point = []

def strike(this_flame)
  point = @flame_arry[this_flame].sum
  next_flame = this_flame + 1
  if @flame_arry[next_flame].nil?
    point
  elsif @flame_arry[next_flame][0] == 10
    special_point = @flame_arry[next_flame][0] + @flame_arry[next_flame + 1][0]
    point + special_point
  else
    special_point = @flame_arry[next_flame][0] + @flame_arry[next_flame][1]
    point + special_point
  end
end

def spare(this_flame)
  next_flame = this_flame + 1
  point = @flame_arry[this_flame].sum
  special_point = @flame_arry[next_flame][0]
  point + special_point
end

@flame_hash_in_arry.select do |hash|
  @flame_hash = hash.to_h
  @flame_hash.each do |key, value|
    if value == 'strike'
      this_flame = key - 1
      point << strike(this_flame)
      break
    elsif (key < 11) && (value.sum == 10)
      this_flame = key - 1
      point << spare(this_flame)
      break
    elsif key < 10
      point << value.sum
    else
      point << value.sum
    end
  end
end

p point.sum
