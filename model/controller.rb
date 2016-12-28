require_relative 'scraper_module'
require_relative 'csv_module'
require_relative 'excel_module'
require_relative 'watch'
require_relative 'watch_list'
require 'pry'

# browser is set to start up in firefox using the compatible geckodriver.exe which is placed in the current path
scrape_file = '../files/items_to_scrape.csv'
url_file = '../files/all_urls.csv'
scraped_data = []


if ARGV.any?

  command = ARGV.first
  options = ARGV[1..-1]
  browser = Scraper.create_browser
  puts "Type anything to continue...(chance to turn off images in browser to speed up scraping)"
  STDIN.gets.chomp

  case command
  when "update urls"
    puts "Estimated Run Time: 5 minutes"
    url_list = Scraper.scrape_all_urls(browser)
    FileAccessor.overwrite_all(url_file, url_list)
    browser.close
  when "scrape"
    count = 1
    url_list = FileAccessor.parse_to_a(url_file)
    watch_list = WatchList.new
    watches_to_scrape = watch_list.load_watches(scrape_file)
    watches_to_scrape.each do |watch|
      puts "Model: #{watch.model} Brand: #{watch.brand} Count: #{count}"
      matching_url = Scraper.match_to_url(watch, url_list)
      count += 1
      if matching_url
        scrape_info = Scraper.scrape_watch(browser, matching_url)
        scrape_info["model"] = watch.model
        p scrape_info
        FileAccessor.push_to_file('jomashop_other_results.csv', scrape_info.values)
        scraped_data << scrape_info.values
        count += 1
        puts "Count - #{count}"
        binding.pry
      end
    end
    Excel.new_file(scraped_data)
  end

end
