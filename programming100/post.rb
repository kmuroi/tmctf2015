require 'net/https'
require 'nokogiri'
require 'chunky_png'

base_url = "http://ctfquest.trendmicro.co.jp"
port     = 43210

def parse_page http, res
  next_url = ""
  body     = res.body
  puts "----------"
  puts body
  puts "----------"

  doc = Nokogiri::HTML.parse(body, nil, "utf-8")
  img_link = ""
  doc.xpath('//img').each {|ele|
    img_link = ele.attribute('src').value
  }
  doc.search('script').each {|script|
    script.content.split("\n").each {|line|
      if line =~ /window.location.href/
        idx      = line.index("=")
        ridx     = line.index("?")
        next_url = line.chomp[idx+2..ridx-1]
      end
    }
  }

  pos   = check_png(http, img_link)
  query = URI.encode_www_form(pos)
  return "#{next_url}?#{query}"
end

def check_png http, link
  res = http.get(link)
  File.open("tmp.png", "wb"){|wfp|
    wfp.write(res.body)
  }
  png = ChunkyPNG::Image.from_file("tmp.png")
  base_pixel = {}
  0.upto(png.width){|w|
    0.upto(png.height){|h|
      pixel = png.get_pixel(w,h)
      if pixel && pixel != 4294967295
        if base_pixel.key?(pixel)
          base_pixel[pixel][:count] += 1
        else
          base_pixel.store(pixel, { :count => 1, :pos => { :x => w, :y => h} })
        end
      end
    }
  }

  p base_pixel
  min_info = nil
  base_pixel.each_pair{|pixel, info|
    if min_info == nil
      min_info = info
    else
      min_info = info if min_info[:count] > info[:count]
    end
  }

  return min_info[:pos]
end

#MAIN
http = Net::HTTP.new("ctfquest.trendmicro.co.jp", port)

response  = http.get('/click_on_the_different_color')
next_link = parse_page(http, response)

while next_link.length > 10
  response  = http.get(next_link)
  p next_link
  next_link = parse_page(http, response)
end
