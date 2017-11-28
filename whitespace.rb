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
				unless command = scanner.scan(/ |\n[ \n\t]/)
					raise Exception, 'missing IMP'
				end
			when :arithmetic
				unless command = scanner.scan(/ [ \t\n]|\t[ \t]/)
					raise Exception, 'missing IMP'
				end				
			when :heap_access
				unless command = scanner.scan(/ |\t/)
					raise Exception, 'missing IMP'
				end
			when :flow_control
				unless command = scanner.scan(/ [ \t\n]|\t[ \t]|\n\n/)
					raise Exception, 'missing IMP'
				end				
			when :i_o
				unless command = scanner.scan(/ [ \t]|\t[ \t]/)
					raise Exception, 'missing IMP'
				end				
			end
			#コマンド切り出し
			#パラメータ切り出し
			#result << imp << command << param
		end
	end	
end
Whitespace.new