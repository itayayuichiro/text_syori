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
    sentence
    evaluate
    p @@functions

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
  def sentence
    while !@scanner.eos?
      block = parser
      next if block.nil?
      if block[0] == :start or block[0] == :print or block[0] == :loop or block[0] == :make_function or block[0] == :call_function or block[0] == :make_variable or block[0] == :end 
        array_str = "@@result"
        @@indent.times {
          array_str = array_str + "[-1]"
        }
        eval(array_str+".push(#{block})")
        @@indent = 0
      end
    end  
    p @@result  
  end
  def parser
    @tokenize = tokenize
    token = @@imps[@tokenize]
    param1,param2 = nil
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
      # 関数呼び出し
      when :call_function
        block = [token, tokenize]
      # インデント
      when :indent
        @@indent = @@indent + 1
      # コードの終わり
      when :end
        block = [token]
      else
          # 一個先を見て判定
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
    return block
  end

  def tokenize
    token = @scanner.scan(/(ログイン|ツイート|リスト作成|リスト|ログアウト|フォロー|\'.+?\'|  |RT|:.+?\n|\n.+? |\d+|.+? | .+?\n|)[\n]*/)
    unless token.match(/  /)
      token = token.delete(" ")
    end      
    return token.chomp
	end

  def evaluate
    @@result.each do |block|
      eval_send_method(block)
    end
  end
  def eval_send_method(block)
      blocks_str = "send('evaluate_#{block[0].to_s.delete(':')}'"
      1.upto(block.length-1){|i|
        blocks_str = blocks_str + ",block[#{i}]"
      }
      eval_str = blocks_str+')'
      eval(eval_str)
  end

  def evaluate_loop(*param)
    param[0].to_i.times {
      eval_send_method(param[1])
    }
  end
  def evaluate_print(*param)
    puts param[0]
  end
  def evaluate_call_function(*param)
    blocks = @@functions[param[0].to_s.delete(':')]
    blocks.each do |block|
      eval_send_method(block)
    end
    return param[0]
  end
  def evaluate_make_function(*param)
    array = []
    1.upto(param.length-1){|i|
      array.push(param[i])
    }
    @@functions[param[0].to_s.delete(':')] = array
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