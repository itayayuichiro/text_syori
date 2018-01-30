# frozen_string_literal:true

require 'strscan'

class Twpro
  @@logined = false # ちゃんとログインしているかの確認
  @@variables = {}
  @@functions = {}
  @@result = []
  @@indent = 0
  def initialize
    f = open(ARGV[0])
    @scanner = StringScanner.new(f.read)
    parser
    eval
  end
  @@imps = {
    'ログイン' => :start,
    'ログアウト' => :end,
    'ツイート' => :print,
    'RT' => :loop,
    'リスト作成' => :make_function,
    'リスト' => :call_function,
    'フォロー' => :make_variable,
    '  ' => :indent,
  }
  def unget_token
    @scanner.unscan
  end
  def parser
    while !@scanner.eos?
      @tokenize = tokenize
      token = @@imps[@tokenize]
      param1,param2 = nil
      p "token:#{token}"
      case token
        # コードの始まり
        when :start
          block = [token]
        # 出力
        when :print
          block = [token, tokenize]
        # 関数生成
        when :make_function
          block = [token, tokenize]
        # 関数
        when :call_function
          block = [token, tokenize]
        # インデント
        when :indent
          @@indent = @@indent + 1
          p "next#{@@indent}"
          next
        else
            p "aaaa"
            @tokenize2 = tokenize
            token2 = @@imps[@tokenize2]
            # 変数生成
            if token2 == :make_variable 
              block = [token2,@tokenize,tokenize]
              token = :make_variable
            # 繰り返し
            elsif token2 == :loop
              block = [token2,@tokenize.to_i]
              token = :loop
            end
        end
        if token == :start or token == :print or token == :loop or token == :make_function or token == :call_function or token == :make_variable 
          if @@indent == 1
            @@result[-1].push(block)
            @@indent = 0
          elsif @@indent == 2
            @@result[-1][-1].push(block)
            @@indent = 0
          else
            @@result.push(block)
          end
        end
    end
    p @@result
  end

  def tokenize
    token = @scanner.scan(/(ログイン|ツイート|リスト作成|リスト|ログアウト|フォロー|\'.+?\'|  |RT|:.+?\n|\n.+? |\d+|.+? | .+?\n|)[\n]*/)
    unless token.match(/  /)
      token = token.delete(" ")
    end
    p token.chomp
      
    return token.chomp
=begin
      unless imp = line.scan(/ログイン|ツイート|リスト作成|リスト|ログアウト|フォロー/)[0]
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
        param2 = line.split(/フォロー/)[1].gsub(/ |\n/, '')
        parser(:make_variable, param,param2)
      end
      }
      debug(@@result)
=end
	end

  # def parser(imp,param,param2)
  #   @@result.push([imp,param,param2])
  #   return [imp,param,param2]
  # end
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
    @@functions[param[0]] = param[1]
  end
  def evaluate_make_variable(*param)
    @@variables[param[0]] = param[1]
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