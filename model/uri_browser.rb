require 'open-uri'

class UriBrowser

  def initialize
    @proxy_addr = "http://108.59.14.208:13010"
  end

  def get(url)
    open(url,
         proxy: @proxy_addr,
         "Pragma" => "no-cache",
         "Accept-Language" => "en-US,en;q=0.8",
         "Upgrade-Insecure-Requests" => "1",
        #  "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36",
         "User-Agent" => "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0",
         "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
         "Referer" => "http://www.jomashop.com/",
         "Connection" => "keep-alive",
         "Cache-Control" => "no-cache"
        ) { |f|
          f.read
        }
  end

end
