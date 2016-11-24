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
      sleep(rand(4))
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

  def scrape_watches
    watch_list = WatchList.new
    watches_to_scrape = watch_list.load_watches("#{@brand}.csv")

    browser = Watir::Browser.new(:firefox)
    puts "ready?"
    gets.chomp

    watches_to_scrape.each do |watch|
      match = @available_urls.find do |item|
        str = /(?<=watch-).*(?=.html)/.match(item).to_s
        str == @model.downcase
      end
    #   if match
    #     browser.goto(match)
    #     page_html = Nokogiri::HTML.parse(browser.html)
    #     brand = page_html.xpath(".//*[@id='Brand']").text.strip
    #     model = page_html.xpath(".//*[@id='Model']").text.strip
    #     type_of_sale = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[1]/span/span")
    #     final_price = page_html.xpath(".//*[@id='final-price']").text.strip
    #     stock = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/span/span/span[1]").text.strip
    #     availability = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/span/span/span[2]").text.strip
    #     if type_of_sale
    #       type_of_sale = type_of_sale.text.strip
    #     end
    #     info = {"brand" => brand, "model" => model, "final_price" => final_price, "availability" => availability, "shipping" => shipping,  "type_of_sale" => type_of_sale}
    #       @watches << JomaWatch.new(info)
    #     end
    #     sleep(rand(5))
    #   end
    # end

    browser.close

  end

end