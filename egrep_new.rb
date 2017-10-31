# /usr/share/dict/words 
class Egrep
	begin
		f = open(ARGV[1])
	rescue Exception => e
		p e.message
		exit
	end
	pattern = ARGV[0]
	f.each{|line|
		begin
			 p line.chomp if line =~ /#{pattern}/
		rescue Exception => e
			p e.message
		end
	}	
end
Egrep.new