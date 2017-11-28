require 'strscan'

class Whitespace
	@code #ソースコードを保持
	def initialize
		@code =" \n\n"	
		tokenize
	end
	@@imps ={
		" " => :stack_mnpl,
		"\t " => :arithmetic,
		"\t\t" => :heap_access,
		"\n" => :flow_control,
		"\t\n" => :i_o,
	}
	def tokenize
		scanner = StringScanner.new(@code)
		result = []
		while !scanner.eos?
			#IMP切り出し
			unless imp = scanner.scan(/ |\n|\t[ \n\t]/)
				raise Exception, 'missing IMP'
			end
			imp = @@imps[imp]
			case imp
			when :stack_mnpl
				unless command = scanner.scan(/ |[ \n\t]/)
					raise Exception, 'missing IMP'
				end
			when :arithmetic
			when :heap_access
			when :flow_control
			when :i_o
			end
			#コマンド切り出し
			#パラメータ切り出し
			#result << imp << command << param
		end
	end	
end
Whitespace.new