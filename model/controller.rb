require_relative 'scraper_module'
require_relative 'csv_module'
require_relative 'excel_module'
require_relative 'watch'
require_relative 'watch_list'
require 'pry'
require 'gmail'

# browser is set to start up in firefox using the compatible geckodriver.exe which is placed in the current path
scrape_file = '../files/test_to_scrape.csv'
url_file = '../files/all_urls.csv'
user = ENV["GMAIL_USER"]
password = ENV["GMAIL_PASS"]
receiver = "albert.farhi5@gmail.com"
output_csv_file = '../files/jomashop_other_results.csv'
output_file = '../files/results.xls'


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
    url_list = FileAccessor.parse_to_a(url_file).flatten
    FileAccessor.clear_file(output_csv_file)
    watch_list = WatchList.new
    watches_to_scrape = watch_list.load_watches(scrape_file)
    watches_to_scrape.each do |watch|
      begin
        puts "Model: #{watch.model} Brand: #{watch.brand} Count: #{count}"
        matching_url = Scraper.match_to_url(watch, url_list)
        if matching_url
          scrape_info = Scraper.scrape_watch(browser, matching_url)
          scrape_info["model"] = watch.model
          p scrape_info
          FileAccessor.push_to_file(output_csv_file, scrape_info.values)
        end
        count += 1
      rescue
        puts "this one got an error"
      end
    end
    binding.pry
    scraped_data = FileAccessor.parse_to_a(output_csv_file)
    Excel.new_file(scraped_data)
    gmail = Gmail.connect(user, password)
      gmail.deliver do
        to receiver
        subject "Joma Results"
        text_part {body "Attached is an excel sheet of recent scrape data"}
        add_file output_file
      end
    gmail.logout
  end

end
