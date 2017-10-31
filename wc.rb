# /usr/share/dict/words 
files = []
option = ""
ARGV.each do |arg|
	files.push(arg) unless arg.match("-")
	option = arg if arg.match("-")
end

total_cnt = 0
total_row = 0
total_byte = 0

def print_option(byte,cnt,row,file,option)
	if option.match(/^(?=.*w)(?=.*l)(?=.*c)/)
		p "#{byte} #{cnt} #{row} #{file}"	
	elsif option.match(/^(?=.*c)(?=.*w)/)
		p "#{cnt} #{row} #{file}"
	elsif option.match(/^(?=.*c)(?=.*l)/)
		p "#{row} #{byte} #{file}"
	elsif option.match(/^(?=.*w)(?=.*l)/)
		p "#{cnt} #{row} #{file}"	
	elsif option.match(/w/)
		p "#{cnt} #{file}"
	elsif option.match(/l/)
		p "#{row} #{file}"
	elsif option.match(/c/)
		p "#{byte} #{file}"				
	end
end

#-w 単語数
# -l　行数
#  -c　バイト数
files.each do |file|
	f = open(file)
	#pattern = ARGV[0]
	cnt = 0
	row = 0
	byte = 0
	f.each{|line|
		line.scan(/[0-9a-zA-Z\-]+/).each do ||
			cnt = cnt + 1
		end
		row = row + 1
		byte = byte + line.bytesize
	}
	total_cnt = total_cnt + cnt
	total_row = total_row + row
	total_byte = total_byte + byte
	print_option(byte,cnt,row,file,option)
end
print_option(total_byte,total_cnt,total_row,"total",option)