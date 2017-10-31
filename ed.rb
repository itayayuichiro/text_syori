class Ed
  $buffer = []
  $position = 0
  def initialize
    f = open(ARGV[0])
    f.each{|line|
     $buffer.push(line)
    }
    mode = nil
    while str = STDIN.gets
      read(str.chomp)
    end
  end
  def read(str)
      eval(str)
  end
  def eval(str)
    unless ['a','c','d','g','i','j','n','p','q','w','wq','','=','0','1','2','3','4','5','6'].include?(str)
      p "?"
    else
      if str == 'q'
        exit     
      elsif str == 'wq'
        File.open(ARGV[0], "w") do |f| 
          $buffer.each do |str|
            f.puts(str)
          end
        end    
        exit
      elsif str == 'a'
        while str = STDIN.gets.chomp
          break if str == '.'
          $buffer.insert($position,str)        
        end
      elsif str.match(/^[0-9]/)
        $position = str.to_i
        p $buffer[$position-1].chomp
      elsif str == ''
        $position = $position + 1
      end
    end
  end
  def print
    
  end
end
Ed.new