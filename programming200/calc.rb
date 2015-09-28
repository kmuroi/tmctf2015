require 'socket'

G = [
   'I'  => 1,
   'IV' => 4,
   'V'  => 5,
   'IX' => 9,
   'X'  => 10,
   'XL' => 40,
   'L'  => 50,
   'XC' => 90,
   'C'  => 100,
   'CD' => 400,
   'D'  => 500,
   'CM' => 900,
   'M'  => 1000,
]
A = {
  "zero"=>0,
  "one"=>1,
  "two"=>2,
  "three"=>3,
  "four"=>4,
  "five"=>5,
  "six"=>6,
  "seven"=>7,
  "eight"=>8,
  "nine"=>9,
  "ten"=>10,
  "eleven"=>11,
  "twelve"=>12,
  "thirteen"=>13,
  "fourteen"=>14,
  "fifteen"=>15,
  "sixteen"=>16,
  "seventeen"=>17,
  "eighteen"=>18,
  "nineteen"=>19,
  "twenty"=>20,
  "thirty"=>30,
  "forty"=>40,
  "fifty"=>50,
  "sixty"=>60,
  "seventy"=>70,
  "eighty"=>80,
  "ninety"=>90,
  "hundred" => 100,
  "thousand" => 1000,
  "million" => 1000000,
  "billion" => 1000000000}
A_M = {
  "hundred" => 100,
  "thousand" => 1000,
  "million" => 1000000,
  "billion" => 1000000000}
A_S = {
  "zero"=>0,
  "one"=>1,
  "two"=>2,
  "three"=>3,
  "four"=>4,
  "five"=>5,
  "six"=>6,
  "seven"=>7,
  "eight"=>8,
  "nine"=>9,
  "ten"=>10,
  "eleven"=>11,
  "twelve"=>12,
  "thirteen"=>13,
  "fourteen"=>14,
  "fifteen"=>15,
  "sixteen"=>16,
  "seventeen"=>17,
  "eighteen"=>18,
  "nineteen"=>19
}

def r_to_a(str)
  puts "Roma to Arabia : #{str}"

  return str.gsub(/(#{G[0].to_a.sort{|l,r| r[0].length <=> l[0].length}.map{|v| v[0]}.join("|")})+/) {|roma|
    result = 0
    roma.scan(/#{G[0].to_a.sort{|l,r| r[0].length <=> l[0].length}.map{|v| v[0]}.join("|")}/).each{|w|
      tmp = G[0][w]
      if tmp == nil
        return w.to_i
      end
      result += tmp
    }
    result.to_s
  }
end

def a_to_a(str)
  puts "Alphabet to Arabia : #{str}"
  return str.gsub(/(\s|#{A.to_a.sort{|l,r| r[0].length <=> l[0].length}.map{|v| v[0]}.join("|")})+/) {|alp|
    if 0 == alp.split(" ").length
      alp
    else
      result     = 0
      prev       = 0
      prev_stack = []
      prev_m     = "billion"
      alp.scan(/#{A.to_a.sort{|l,r| r[0].length <=> l[0].length}.map{|v| v[0]}.join("|")}/).each{|w|
        if A_M.key?(w)
          prev_stack.push([ w, prev ])
          prev = 0
          tail = prev_stack.length

          if A[w] > A[prev_m]
            value = 0
            while tmp = prev_stack.pop()
              if A[tmp[0]] <= A[w]
                value += tmp[1]
              else
                result += tmp[1]
              end
            end
            result += value * A[w]
          else
            prev_stack[tail-1][1] *= A[w]
          end

          prev_m = w
        else
          prev += A[w]
        end
      }
      result += prev
      if prev_stack.length > 0
        value = 0
        while tmp = prev_stack.pop()
          value += tmp[1]
        end
        result += value
      end
      " #{result}"
    end
  }
end

s = TCPSocket.open("ctfquest.trendmicro.co.jp", 51740)

while line = s.recv(2048)
  formula = r_to_a(line.gsub(",", ""))
  formula = a_to_a(formula)

  puts line
  puts formula

  eq  = formula.rindex("=")
  if nil != eq
    val = eval(formula[0..eq-1])
    s.write(val.to_s)
  else
    break
  end
end
