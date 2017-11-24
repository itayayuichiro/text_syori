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
    addr = '(?:\d+|[.$,;]|\/.*\/)'
    cmnd = '(wq|[acdgijnpqrw=]|\z)'
    prmt = '(.*)'
    unless str.match(/\A(#{addr}(,#{addr})?)?#{cmnd}(#{prmt})?\z/)
      p "?"
    else
      address = str.match(/\A(#{addr}(,#{addr})?)?#{cmnd}(#{prmt})?\z/)[1]
      address2 = str.match(/\A(#{addr}(,#{addr})?)?#{cmnd}(#{prmt})?\z/)[2]
      cmd = str.match(/\A(#{addr}(,#{addr})?)?#{cmnd}(#{prmt})?\z/)[3]
      prin = str.match(/\A(#{addr}(,#{addr})?)?#{cmnd}(#{prmt})?\z/)[4]
      if cmd == 'q'
        exit     
      elsif cmd == 'wq'
        File.open(ARGV[0], "w") do |f| 
          $buffer.each do |cmd|
            f.puts(cmd)
          end
        end    
        exit
      elsif cmd == 'a'
        cnt = 0
        while cmd = STDIN.gets.chomp
          break if cmd == '.'
          $buffer.insert(address.to_i+cnt,cmd)        
          cnt = cnt + 1
        end
      elsif cmd == 'p'
        ((address2.gsub(",","").to_i-address.split(',')[0].to_i)+1).times{|i|
          p $buffer[i+address.split(',')[0].to_i-1].chomp
        }
      elsif cmd == 'd'
          $buffer.delete_at($position) 
      elsif cmd == '' && address.nil?
        $position = $position + 1
      elsif address.match(/^[0-9]/)
        $position = address.to_i
        p $buffer[$position-1].chomp
      end
    end
  end
  def print
    
  end
end
Ed.new