require 'net/http'
require 'uri'

class NetBrowser

  def get(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    request["Pragma"] = "no-cache"
    request["Accept-Language"] = "en-US,en;q=0.8"
    request["Upgrade-Insecure-Requests"] = "1"
    request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
    request["Referer"] = "http://www.jomashop.com/"
    request["Connection"] = "keep-alive"
    request["Cache-Control"] = "no-cache"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.body
  end

end
