#! /usr/bin/env ruby

#コマンドラインで引数取得
score_result = Array.new(ARGV)
#配列全体が[0]番目の要素となっているのをsplitで分ける
score_x_array = score_result[0].split(",")#p score_array #=>["6", "3", "9", "0", "0", "3", "8", "2", "7", "3", "X", "9", "1", "8", "0", "X", "6", "4", "5"]
score_array = score_x_array.map{|x| x=="X" ? "10" : x}#Xを10に変換
score_integer_array = score_array.map(&:to_i) #配列の中身をintegerに変換
@score_integer_array = score_integer_array

@flame_arry = []

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
	if i == 10
		score_integer_array[-3 .. -1].each_slice(3) do |a, b, c|
			 score = [a, b, c]
			 @flame_arry << score
		end
		break
	elsif	a == 10
		score = [a]
		@flame_arry << score
		score_integer_array.insert(10, 0)
		next
	else
		score = [a, b]
		@flame_arry << score
	end
end

#@flame_arry#=>[[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10], [9, 1], [8, 0], [10], [6, 4, 5]]

score_result = Array.new(ARGV)
score_x_array = score_result[0].split(",")
score_array = score_x_array.map{|x| x=="X" ? "10" : x}#Xを10に変換
score_integer_array = score_array.map(&:to_i) #配列の中身をintegerに変換
@score_integer_array = score_integer_array

flame_hash_in_arry = []
@flame_hash_in_arry = flame_hash_in_arry

score_integer_array.each_slice(2).with_index(1) do |(a, b), i|
	if i == 10
		score_integer_array[-3 .. -1].each_slice(3) do|a, b, c|
			flame = {i => [a, b, c]}
			@flame_hash_in_arry << flame
		end
		break
	elsif	a == 10
		flame = {i => "strike"}
		@flame_hash_in_arry << flame
		@score_integer_array.insert(10, 0)
		next
	else
		flame = {i => [a, b]}
		@flame_hash_in_arry << flame
	end
end

#@flame_hash_in_arry#この時点ではまだkey指定できない

point = []

@flame_hash_in_arry.select do |hash|
	@flame_hash = hash.to_h
	@flame_hash.each do |key, value|

		def strike
			point = @flame_arry[@this_flame].sum
			special_point = @flame_arry[@next_flame][0] + @flame_arry[@next_flame][1]
			point + special_point
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
		elsif value.sum == 10
			@next_flame = key
			@this_flame = key - 1
			point << spare
			break
		else
			point << value.sum
		end

	end
end

p point.sum

#一旦完成
#$ruby bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
#139
#動作確認OK

#game = score_integer_array.each_slice(2).to_a
#p game
#game.map do |first, second|
#	if first == 10
#		game.insert(first, 0)
#		p first
#		next
#	else
#		p [first, second]
#	end
#end

#{1=>[6, 3]}
#{2=>[9, 0]}
#{3=>[0, 3]}
#{4=>[8, 2]}　スペア
#{5=>[7, 3]} スペア
#{6=>"strike"}　ストライク
#{7=>[9, 1]}　スペア
#{8=>[8, 0]}
#{9=>"strike"}　ストライク
#{10=>[6, 4, 5]}