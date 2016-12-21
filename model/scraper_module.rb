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



  def self.scrape_watch(browser, url)
    if url
      browser.goto(url)
      sleep(rand(3.0))
      parse_product_info(browser.html)
    end
  end

  def self.parse_product_info(page)
    page_html = Nokogiri::HTML.parse(page)
    brand = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[1]/h1/span[2]").text.strip
    joma_model = page_html.xpath(".//*[@id='Model']").text.strip
    type_of_sale = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[1]/span/span")
    final_price = page_html.xpath(".//*[@id='final-price']").text.strip
    availability = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/span/span/span[1]").text.strip
    shipping = page_html.xpath(".//*[@id='Brand']").text.strip
    retai_price = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/div[1]/div/ul/li[1]/span").text.strip
    old_price = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/div[1]/div/ul/li[2]/span").text.strip
    description = page_html.xpath(".//*[@id='tab-container-details']/div/div[1]/div").text.strip
    table_data = [".//*[@id='Brand']", ".//*[@id='Series']", ".//*[@id='Gender']",".//*[@id='Watch Label']",".//*[@id='Movement']",".//*[@id='Dial Type']", ".//*[@id='Dial Color']",".//*[@id='Crystal']", ".//*[@id='Hands']",".//*[@id='Second Markers']", ".//*[@id='Dial Markers']", ".//*[@id='Case Size']", ".//*[@id='Case Material']",".//*[@id='Crown']",".//*[@id='Case Shape']",".//*[@id='Case Back']",".//*[@id='Bezel']",".//*[@id='Band Type']",".//*[@id='Band Type']",".//*[@id='Clasp']",".//*[@id='Water Resistance']", ".//*[@id='Calendar']",".//*[@id='Functions']", ".//*[@id='Features']", ".//*[@id='Style']", ".//*[@id='UPC Code']", ".//*[@id='Internal ID']", ".//*[@id='Product Category']"]
    table_results = table_data.map do|field|
      if page_html.xpath(field)
        page_html.xpath(field).text.strip
      else
        ""
      end
    end
    if type_of_sale
      type_of_sale = type_of_sale.text.strip
    end
    {"brand" => brand, "joma_model" => joma_model, "final_price" => final_price, "availability" => availability, "shipping" => shipping,  "type_of_sale" => type_of_sale,"description" => description, "table" => table_results.join(" "), "old price" => old_price, "retail price" => retai_price}
  end

  def self.match_to_url(watch, urls)
    urls = urls.dup
    urls.find do |url|
      url = url.split('com\/').last
      url.slice!('.html')
      url.delete!('-')
      model = keep_alphanumeric_chars(watch.model.split(' ').first)
      brand = keep_alphanumeric_chars(watch.brand)
      (url.end_with?(model) && url.include?(brand)) && (url.include?('openbox') == false)
    end
  end

  def self.keep_alphanumeric_chars(str)
    str.gsub(/\W*/, "").downcase
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
  # ruby controller.rb "scrape" "watches_to_scrape.csv"
