def kmp_init(patt)
	i = 0
	j = -1
	m = patt.length
	back = [-1]
	while i < m - 1
		while j >= 0 && patt[i] != patt[j]
			j = back[j]
			puts "i:#{i} j:#{j} #{back[j]}"
		end
		puts "i:#{i} j:#{j} #{back[j]}"
		i = i + 1
		j = j + 1
		back[i] = j
	end
	return back
end

def kmp_match(text,patt)
	back = kmp_init(patt)
	i = j = 0
	n = text.length
	m = patt.length
	while i < n && j < m
		while j >= 0 && text[i] != patt[j]
			j = back[j]
		end
		i = i + 1
		j = j +1
	end
	if j == m
		return (i - j)
	end
end

text = ["b","b","b","b","a","b","c","c","c","c"]
pattern = ["b","c","c"]
pattern = ["a","a","b","a","a","a","b","c"]
n = 10
m = 4
p kmp_match(text,pattern);
