require 'watir'
require 'nokogiri'

module Scraper

  def self.scrape_urls(brand)
    urls = []
    count = 1
    browser = Watir::Browser.new(:firefox)
    browser.goto("http://search.jomashop.com/search#w=#{brand}")
    browser.goto(browser.url + "?p=#{count}")
    sleep(5)
    loop do
      count += 1
      new_url = browser.url.to_s
      new_url = new_url.sub(/(?<==).*/, "#{count}")
      browser.goto(new_url)
      page = Nokogiri::HTML.parse(browser.html)
      break if page.css(".item").empty?
      page.css(".item").each do |item|
        urls << item.at_css(".price-link")['href']
      end
    end
    browser.close
  end

end