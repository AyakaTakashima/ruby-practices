#!/usr/bin/env ruby

require "date"
require "optparse"

options = ARGV.getopts("y:", "m:")

OptionParser.new do |opt|
  opt.on('-y VAL') do |v|
    params[:y] = v.to_i
  end

  opt.on('-m VAL') do |v|
    params[:m] = n.to_i
  end
end.parse!

#puts options #=>{"y"=>"2022", "m"=>11}

##################オプション定義ここまで###########################

today = Date.today
date = Date.new

if options["m"]
  month = options["m"].to_i
else
  month = today.mon #今月
end

if options["y"]
  year = options["y"].to_i
else
  year = today.year #今年
end

#上記でカレンダーの題名
head = "#{month}月　#{year}年" #デフォで今年の年月が出てくる
puts head.center(16) #中央に配置

#曜日部分
weeks = Date.new.wday #wdayで曜日を表す数字を取得
week = %w(日 月 火 水 木 金 土) #%wは後置してある（）の中の要素で配列を作成する
puts week.join(" ") #joinで横並び＆曜日同士の文字列間が狭いのでスペース追加

#「最初の曜日は1日目のwdayですよ」
first_wday = Date.new(year,month,1).wday 

#曜日と日付を合わすための空白
print "   "*first_wday #最初の曜日の値の分、スペースを配置（例えば木曜は4なので4×スペース3つ分が配置される）

date.mday #日付
last_date = Date.new(year,month,-1).mday #末日は最後から−1日のmdayの日

for i in (1..last_date) do #1..last_dateを繰り返しします
  print "#{i}".center(2)#centerでオブジェクト（1..last_date）をいい感じに配置
  first_wday = first_wday + 1 #fday（first_wday）に1を足すのを繰り返す
  if first_wday % 7 == 0#÷7であまりがゼロだったら折り返すようにする
    puts#putsの後に何も書かないことで何も表示しない＆putsは改行ありで表示なので必然的に改行される
	else
    print " "#上記（fday%7 == 0）以外では間に空白を置くよう指示
  end
end

print("\n")#printによる末尾の%が表示されないように改行\nを追加
