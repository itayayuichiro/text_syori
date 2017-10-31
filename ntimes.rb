# /usr/share/dict/words 

def ntimes(n,&blocks)
	n.times{|i|
		yield
	}
end
array = [1,2,3,4,5]
ntimes(2,array)