# /usr/share/dict/words 
f = open(ARGV[1])
pattern = ARGV[0]
f.each{|line|
 p line.chomp if line =~ /#{pattern}/
}