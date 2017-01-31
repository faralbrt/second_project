require 'nokogiri'

class UrlFetcher

  def initialize(browser = NetBrowser)
    @browser = browser.new
    @urls = []
    @parsed_page = nil
  end

  def scrape_all_urls
    count = 1
    loop do
      page = @browser.get("http://www.jomashop.com/media/sitemaps/sitemap_00#{count}.xml")
      @parsed_page = Nokogiri::HTML.parse(page)
      product_urls = parse_product_urls
      break if product_urls.empty?
      @urls += product_urls
      puts "#{count} - #{@urls.length}"
      count += 1
      sleep(3)
    end
    return @urls
  end

  private
  def parse_product_urls
    urls = @parsed_page.css("url").map do |object|
      parse_url(object)
    end
    urls.compact
  end

  def parse_url(object)
    url = object.at_css("loc").text
    return url if url.include?(".html")
    return nil
  end

end
