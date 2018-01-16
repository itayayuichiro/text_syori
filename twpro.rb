# frozen_string_literal:true

require 'strscan'

class Twpro
  @@logined = false # ちゃんとログインしているかの確認
  @@variables = {}
  @@functions = {}
  @@result = []

  def initialize
    tokenize(ARGV[0])
    eval
  end
  @@imps = {
    'ログイン' => :start,
    'ログアウト' => :end,
    'ツイート' => :print,
    '3RT' => :loop,
    'リスト作成' => :make_function,
    'リスト' => :call_function,
    'フォロー' => :make_variable,

  }

  def tokenize(file)
    f = open(file)
  	#pattern = ARGV[0]
  	f.each{|line|
#      puts line

      unless imp = line.scan(/ログイン|\d+RT|ツイート|リスト作成|リスト|ログアウト|フォロー/)[0]
        raise Exception, '字句解析エラー'
      end
      # debug(imp)
      # debug(@@imps[imp])
      case @@imps[imp]
      when :start
        parser(:start, nil, nil)
      when :end
        parser(:end, nil, nil)
      when :print
        param = line.scan(/\'.+?\'/)[0]
        parser(:print, param, nil)
      when :loop
        param = line.scan(/^\dRT/)[0].delete("RT")
          # unless imp = line.scan(/\d+RT|ツイート|リスト/)[0]
          #   raise Exception, '字句解析エラー'
          # end
          # case @@imps[imp]
          # when :print
          #   param = line.scan(/\'.+?\'/)[0]
          #   param2 = parser(:print, param, nil)
          # end
        param2 = line.scan(/^\dRT/)[0].delete("RT")
        parser(:loop, param, param2)
      when :make_function
        param = line.scan(/^リスト作成:/)[0].delete("リスト作成:")
        param2 = nil
        parser(:make_function, param,param2)
      when :call_function
        param = line.scan(/^リスト:/)[0].delete("リスト:")
        param2 = nil
        parser(:call_function, param, param2)
      when :make_variable
        param = line.split(/フォロー/)[0].delete(' ')
        param2 = line.split(/フォロー/)[1].gsub(/ |\n/, "")
        parser(:make_variable, param,param2)
      end
      }
      debug(@@result)
	end

  def parser(imp,param,param2)
    @@result.push([imp,param,param2])
    return [imp,param,param2]
  end
  def eval
    @@result.each do |block|
      send("evaluate_#{block[0].to_s.delete(':')}",block[1])
    end
  end

  def evaluate_loop(*param)
    # unless imp = scanner.scan(/ ツイート| リスト/)
    #   raise Exception, 'missing IMP'
    # end
    # imp = @@imps[imp.delete(' ')]
    # 3.times {
    #   case imp
    #   when :print
    #     evaluate_print(scanner)
    #     scanner.unscan
    # }
    # scanner.scan
  end
  def evaluate_print(*param)
    puts param[0]
  end
  def evaluate_call_function(*param)
    puts param[0]
  end
  def evaluate_make_function(*param)
    @@functions[:name] = "base"
  end
  def evaluate_make_variable(*param)
    @@functions[:name] = "base"
  end
  def evaluate_end(*param)
    exit
  end
  def evaluate_start(*param)
    @@logined = true
  end
  def logined_check
    return @logined
  end
  def debug(str)
    p str
  end
end
Twpro.new
