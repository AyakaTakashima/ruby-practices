#! /usr/bin/env ruby

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(",")#p score_array #=>["6", "3", "9", "0", "0", "3", "8", "2", "7", "3", "X", "9", "1", "8", "0", "X", "6", "4", "5"]
score_array = score_x_array.map{|x| x=="X" ? "10" : x}#Xを10に変換
score_integer_array = score_array.map(&:to_i)
@score_integer_array = score_integer_array

@score_integer_array#=>[6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 6, 4, 5]
@flame_arry = []

#score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
#	if (i == 10) && (a == 10)
#		score_integer_array[-3 .. -1].each_slice(3) do|a, b, c|
#			score = [a, b, c]
#			@flame_arry << score
#			break
#		end
#	elsif i == 10
#		if @score_integer_array[-1] == @score_integer_array[-2]
#			score_integer_array[-2 .. -1].each_slice(2) do |a, b|
#				score = [a, b]
#				@flame_arry << score
#			end
#		else
#			score_integer_array[-3 .. -1].each_slice(3) do |a, b, c|
#				score = [a, b, c]
#				@flame_arry << score
#			end
#		end
#		break
#	elsif (i < 10) && (a == 10) && (b == 10)#ストライクが2フレーム連続続いた場合
#		score = [a, 0]
#		#score_integer_array.insert(i, 0)
#		@flame_arry << score
#		#p score_integer_array
#		if b == 10
#			score = [b, 0]
#			#score_integer_array.insert(i, 0)
#			@flame_arry << score
#		end
#		next
#	elsif	(i < 10) && (a == 10)#1フレームだけストライクの場合
#		b = 0
#		score = [a, b]
#		score_integer_array.insert(i, 0)
#		@flame_arry << score
#		#p score_integer_array
#		next
#	else
#		score = [a, b]
#		@flame_arry << score
#	end
#end

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
	if (a == 10) && (b == 10)#ストライクが2フレーム連続続いた場合
		score = [a, 0]
		#score_integer_array.insert(i, 0)
		@flame_arry << score
		#p score_integer_array
		if b == 10
			score = [b, 0]
			#score_integer_array.insert(i, 0)
			@flame_arry << score
		end
		next
	elsif	a == 10#1フレームだけストライクの場合
		b = 0
		score = [a, b]
		score_integer_array.insert(i, 0)
		@flame_arry << score
		#p score_integer_array
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

@flame_arry#=>[[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [6, 4, 5], [5, nil]]

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(",")
score_array = score_x_array.map{|x| x=="X" ? "10" : x}#Xを10に変換
score_integer_array = score_array.map(&:to_i) #配列の中身をintegerに変換
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
		#score_integer_array[-3 .. -1].each_slice(3) do|a, b, c|
		#	flame = {i => [a, b, c]}
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

@flame_hash_in_arry#=>[{1=>[6, 3]}, {2=>[9, 0]}, {3=>[0, 3]}, {4=>[8, 2]}, {5=>[7, 3]}, {6=>"strike"}, {7=>[9, 1]}, {8=>[8, 0]}, {9=>"strike"}, {10=>[6, 4, 5]}]
#この時点ではまだkey指定できない

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
