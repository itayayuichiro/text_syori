def mat(text,pattern,m,n) 
	for i in 0...(n-m) do
		cnt = 0
		for j in 0..m do
			if text[i+j]==pattern[j]
				cnt = cnt + 1
			end
			if cnt == m
				return "hit"
			end
		end
	end
	return "no hit"
end

text = ["b","b","b","b","a","b","c","c","c","c"]
pattern = ["a","b","c"]
n = 10
m = 3
p mat(text,pattern,m,n);
