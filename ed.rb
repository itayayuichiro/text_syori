class Ed
  $buffer = []
  $position = 0
  def initialize
    f = open(ARGV[0])
    f.each{|line|
     $buffer.push(line)
    }
    $position = $buffer.length-1
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
      puts "?"
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
      elsif cmd == 'w'
        File.open(ARGV[0], "w") do |f| 
          $buffer.each do |cmd|
            f.puts(cmd)
          end
        end
      #後ろに挿入
      elsif cmd == 'a'
        if address.nil?
          cnt = 0
          while cmd = STDIN.gets.chomp
            break if cmd == '.'
            $buffer.insert($position+cnt,cmd)
            cnt = cnt + 1
          end
        else
          cnt = 0
          while cmd = STDIN.gets.chomp
            break if cmd == '.'
            $buffer.insert(address.to_i+cnt,cmd)
            cnt = cnt + 1
          end
        end
      #前に挿入
      elsif cmd == 'i'
        if address.nil?
          cnt = 0
          while cmd = STDIN.gets.chomp
            break if cmd == '.'
            $buffer.insert($position+cnt-1,cmd)        
            cnt = cnt + 1
          end  
        else
          cnt = 0
          while cmd = STDIN.gets.chomp
            break if cmd == '.'
            $buffer.insert(address.to_i+cnt-1,cmd)        
            cnt = cnt + 1
          end
        end
      #出力
      elsif cmd == 'p'
        if address.nil?
            puts $buffer[$position].chomp
        else
          ((address2.gsub(",","").to_i-address.split(',')[0].to_i)+1).times{|i|
            puts $buffer[i+address.split(',')[0].to_i-1].chomp
          }
        end
      #結合
      elsif cmd == 'j'
        str=""
        ((address2.gsub(",","").to_i-address.split(',')[0].to_i)+1).times{|i|
          str = str+$buffer.shift(address.split(',')[0].to_i).join("").chomp
        }
        $buffer.insert(address.split(',')[0].to_i-1,str)
      #置換
      elsif cmd == 'c'
        ((address2.gsub(",","").to_i-address.split(',')[0].to_i)+1).times{|i|
          $buffer.shift(address.split(',')[0].to_i).join("").chomp
        }
        str = ""
        while cmd = STDIN.gets.chomp
          break if cmd == '.'
          $buffer.insert(address.split(',')[0].to_i-1,cmd)
        end
      #諦め
      elsif cmd == 'g'
        buffer = []
        ((address2.gsub(",","").to_i-address.split(',')[0].to_i)+1).times{|i|
          buffer.push($buffer.shift(address.split(',')[0].to_i).join("").chomp)
        }
      #削除
      elsif cmd == 'd'
        if address.nil?
         $buffer.delete_at($position)
        else
          $buffer.slice!(address.split(',')[0].to_i-1..address2.gsub(",","").to_i-1)
        end
      elsif cmd == 'n'
        ((address2.gsub(",","").to_i-address.split(',')[0].to_i)+1).times{|i|
          puts "#{i+address.split(',')[0].to_i} #{$buffer[i+address.split(',')[0].to_i-1].chomp}"
        }
      elsif cmd == '='
          puts $buffer.length
      elsif address.match(/\d+/)
        $position = address.to_i
        puts $buffer[$position-1].chomp
      else
        puts "?"
      end
    end
  end
end
Ed.new