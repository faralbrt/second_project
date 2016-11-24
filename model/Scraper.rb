require 'watir'
require 'nokogiri'

module Scraper

  def scrape_urls(brand)
    count = 1
    browser = Watir::Browser.new(:firefox)
    puts "ready?"
    gets.chomp
    browser.goto("http://search.jomashop.com/search#w=#{brand}")
    sleep(5)
    if browser.url.include?("search")
      new_url = "http://www.jomashop.com/#{brand}.html?p=1"
      browser.goto(new_url)
    else
      browser.goto(browser.url + "?p=#{count}")
    end
    loop do
      count += 1
      new_url = browser.url.to_s
      new_url = new_url.sub(/(?<==).*/, "#{count}")
      browser.goto(new_url)
      page = Nokogiri::HTML.parse(browser.html)
      break if page.css(".item").empty?
      page.css(".item").each do |item|
        @available_urls << item.at_css(".price-link")['href']
      end
    end
    browser.close
    return
  end

end