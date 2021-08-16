#! /usr/bin/env ruby

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(",")
score_array = score_x_array.map{|x| x=="X" ? "10" : x}
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
		next
	elsif	a == 10
		b = 0
		score = [a, b]
		score_integer_array.insert(i, 0)
		@flame_arry << score
		next
	else
		score = [a, b]
		@flame_arry << score
	end

end

if @flame_arry[10] != nil
	flame = @flame_arry[10].compact
	@flame_arry[9] << flame[0]
end

if @flame_arry[11] != nil
	flame = @flame_arry[11].compact
	@flame_arry[9] << flame[0]
end

if @flame_arry[12] != nil
	flame @flame_arry[12].compact
	@flame_arry[9] << flame[0]
end

@flame_arry

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(",")
score_array = score_x_array.map{|x| x=="X" ? "10" : x}
score_integer_array = score_array.map(&:to_i)
@score_integer_array = score_integer_array

flame_hash_in_arry = []
@flame_hash_in_arry = flame_hash_in_arry

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
	if i == 10 && a == 10
		score_integer_array[-3 .. -1].each_slice(3) do|a, b, c|
			flame = {i => [a, b, c]}
			@flame_hash_in_arry << flame
			break
		end
	elsif i == 10
		flame = {i => @flame_arry[9]}
		@flame_hash_in_arry << flame
		break
	elsif i == 11
		break
	elsif	a == 10
		flame = {i => "strike"}
		@flame_hash_in_arry << flame
		@score_integer_array.insert(i, 0)
		next
	else
		flame = {i => [a, b]}
		@flame_hash_in_arry << flame
	end
end

point = []

@flame_hash_in_arry.select do |hash|
	@flame_hash = hash.to_h
	@flame_hash.each do |key, value|
		def strike
			point = @flame_arry[@this_flame].sum
			if @flame_arry[@next_flame] == nil
				point
			elsif @flame_arry[@next_flame][0] == 10
				special_point = @flame_arry[@next_flame][0] + @flame_arry[@next_flame+1][0]
				point + special_point
			else
				special_point = @flame_arry[@next_flame][0] + @flame_arry[@next_flame][1]
				point + special_point
			end
		end

		def spare
			point = @flame_arry[@this_flame].sum
			special_point = @flame_arry[@next_flame][0]
			point + special_point
		end

		if value == "strike"
			value = 10
			@next_flame = key
			@this_flame = key - 1
			point << strike
			break
		elsif (key < 11) && (value.sum == 10)
			@next_flame = key
			@this_flame = key - 1
			point << spare
			break
		elsif key < 10
			point << value.sum
		else
			point << value.sum
		end

	end
end

p point.sum
