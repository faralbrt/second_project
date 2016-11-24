require_relative 'model/watch_list'
require_relative 'model/watch'
require_relative 'model/csv_parser'

watch_list = WatchList.new
watches = watch_list.load_watches('model/movado.csv')

browser = Watir::Browser.new(:firefox)

gets.chomp

watches.each do |watch|
	browser.goto(watch.url)
	page_html = Nokogiri::HTML.parse(browser.html)
	model = page_html.xpath(".//*[@id='Model']")
	type_of_sale = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[1]/span/span")
	if model
		model = model.text.strip
		final_price = page_html.xpath(".//*[@id='final-price']").text.strip
		stock = page_html.xpath(".//*[@id='product_addtocart_form']/div[2]/div[2]/div[2]/div[1]/span/span/span[1]").text.strip
		if type_of_sale
			type_of_sale = type_of_sale.text.strip
		end
		puts "#{model.upcase}: #{final_price}\n Availability: #{stock}\n #{type_of_sale}"
	end
	sleep(rand(5))
end

browser.close


