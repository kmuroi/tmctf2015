
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
            puts "TMP RESULT -> #{result}"
          else
            prev_stack[tail-1][1] *= A[w]
            puts "PUSH STACK -> #{prev_stack[tail-1][1]}"
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

puts r_to_a("VIII")
puts r_to_a("IX")
puts r_to_a("0")
puts r_to_a("0 + III * IX =")
puts r_to_a("VII * VII =")
puts a_to_a("51 * 3 + seventy four")
puts a_to_a("565 - fifty three thousand six hundred seventy one * ( one hundred fourteen - four ) * ( four thousand four hundred ninety six - seven hundred seventy seven ) =")
puts a_to_a("two thousand one hundred twenty five + zero - nine hundred ninety eight * 93672 + sixty eight thousand one hundred forty eight - 1958 =")
puts a_to_a("( 148 + one thousand three hundred ninety five ) * 606 + five hundred five thousand eleven - four thousand five hundred sixteen + 47799 - 8215 =")
puts a_to_a("four hundred nine + thirty thousand five hundred eighty eight - ( 91 + four thousand four hundred thirty two ) * 9302089 - twenty five thousand six hundred fifteen + three hundred ninety seven thousand nine hundred nineteen * ( 6 - 8 )")
puts a_to_a("twenty four million eight hundred seventy two thousand six hundred twenty six")

