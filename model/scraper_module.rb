require 'watir'
require 'nokogiri'

class Scraper

  def self.scrape_all_urls(browser)
    count = 1
    all_urls = []
    browser.goto("http://www.jomashop.com/media/sitemaps/sitemap_00#{count}.xml")
    until no_urls?(browser.html)
      sleep(3 + rand(1.0))
      parse_product_urls(browser.html, all_urls)
      puts "count - #{count} URL's = #{all_urls.length}"
      count += 1
      browser.goto("http://www.jomashop.com/media/sitemaps/sitemap_00#{count}.xml")
    end
    return all_urls
  end

  def self.create_browser
    Watir::Browser.new(:firefox)
  end

  def self.parse_product_urls(page, url_arr = [])
    page = parse_page(page)
    page.css("url").each do |object|
      if product_url?(object)
        url_arr << parse_url(object)
      end
    end
    return url_arr
  end

  def self.product_url?(object)
    parse_url(object).include?(".html")
  end

  def self.parse_url(object)
    object.at_css("loc").text
  end

  def self.no_urls?(page)
    page = parse_page(page)
    if page.css("url")[0] == nil
      return true
    else
      return false
    end
  end

  def self.parse_page(page)
    page = Nokogiri::HTML.parse(page)
  end



  def scrape_watches
    watch_list = WatchList.new
    watches_to_scrape = watch_list.load_watches('watches_to_scrape.csv')

    browser = Watir::Browser.new(:firefox)
    puts "ready?"
    gets.chomp

    counter = 1
    CSV.open('jomashop_other_results.csv', 'a') do |csv_row|
      watches_to_scrape.each do |watch|
        match = @available_urls.find { |item| item.gsub(/\W*/, "").include?(watch.model.gsub(/\W*/, "").downcase) }
        if match
          browser.goto(match)
          sleep(rand(3.0))
          page_html = Nokogiri::HTML.parse(browser.html)
          brand = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[1]/h1/span[2]").text.strip
          type_of_sale = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[1]/span/span")
          final_price = page_html.xpath(".//*[@id='final-price']").text.strip
          availability = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/span/span/span[1]").text.strip
          shipping = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/span/span/span[2]").text.strip
          if type_of_sale
            type_of_sale = type_of_sale.text.strip
          end
          info = {"brand" => brand, "model" => watch.model, "final_price" => final_price, "availability" => availability, "shipping" => shipping,  "type_of_sale" => type_of_sale}
          p info
          puts "Count: #{counter}"
          counter +=1
          csv_row << info.values
          @joma_watches << JomaWatch.new(info)
        end
      end
    end
    browser.close
  end


end


### ===== UNUSED METHODS (scrape by brand, or by whole category)

  # def scrape_urls_by_brand(brand)
  #   count = 1
  #   browser = Watir::Browser.new(:firefox)
  #   puts "ready?"
  #   gets.chomp
  #   browser.goto("http://search.jomashop.com/search#w=#{brand}")
  #   sleep(5)
  #   if browser.url.include?("search")
  #     new_url = "http://www.jomashop.com/#{brand}.html?p=1"
  #     browser.goto(new_url)
  #   else
  #     browser.goto(browser.url + "?p=#{count}")
  #   end
  #   loop do
  #     sleep(rand(4))
  #     count += 1
  #     new_url = browser.url.to_s
  #     new_url = new_url.sub(/(?<==).*/, "#{count}")
  #     browser.goto(new_url)
  #     page = Nokogiri::HTML.parse(browser.html)
  #     break if page.css(".item").empty?
  #     page.css(".item").each do |item|
  #       @available_urls << item.at_css(".price-link")['href']
  #     end
  #   end
  #   browser.close
  #   return
  # end

  # def self.scrape_urls(browser)
  #   # browser = Watir::Browser.new(:firefox)
  #   # puts "ready?"
  #   # gets.chomp
  #   browser.goto("http://www.jomashop.com/#{@category}.html" + "?p=#{count}")
  #   sleep(6)
  #   CSV.open(@filename, "w") do |csv_row|
  #     until count >= finish
  #       sleep(rand(1.0))
  #       sleep(2)
  #       page = Nokogiri::HTML.parse(browser.html)
  #       break if page.css(".item").empty?
  #       page.css(".item").each do |item|
  #         @available_urls << item.at_css(".price-link")['href']
  #         csv_row << [item.at_css(".price-link")['href']]
  #       end
  #       new_url = browser.url.to_s
  #       new_url = new_url.sub(/(?<==).*/, "#{count}")
  #       puts "count - #{count} URL's = #{@available_urls.length}"
  #       count += 1
  #       browser.goto(new_url)
  #     end
  #   end
  #   browser.close
  #   return
  # end
