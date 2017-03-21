require_relative 'url_fetcher'
require_relative 'url_matcher'
require_relative 'net_browser'
require_relative 'watir_browser'
require_relative 'uri_browser'
require_relative 'product_parser'
require_relative 'csv_module'
require_relative 'excel_module'
require_relative 'watch'
require_relative 'watch_list'
require_relative 'url_matcher'
require 'pry'
require 'gmail'

# browser is set to start up in firefox using the compatible geckodriver.exe which is placed in the current path
SCRAPE_FILE     = File.join(Dir.home, '/second_project/files/items_to_scrape.csv')
URL_FILE        = File.join(Dir.home, '/second_project/files/all_urls.csv')
OUTPUT_CSV_FILE = File.join(Dir.home, '/second_project/files/jomashop_other_results.csv')
OUTPUT_FILE     = File.join(Dir.home, '/second_project/files/results.xls')
USER = ENV["GMAIL_USER"]
PASSWORD = ENV["GMAIL_PASS"]
RECEIVER = "albert.farhi5@gmail.com"


  command = ARGV.first
  options = ARGV[1..-1]

  case command
  when "update urls"
    puts "Estimated Run Time: 2 minutes"
    fetcher = UrlFetcher.new
    url_list = fetcher.scrape_all_urls
    FileAccessor.overwrite_all(URL_FILE, url_list)
  when "scrape"
    start_time = Time.now
    count = 1
    url_list = FileAccessor.parse_to_a(URL_FILE).flatten
    url_matcher = UrlMatcher.new(url_list)
    FileAccessor.clear_file(OUTPUT_CSV_FILE)
    watch_list = WatchList.new
    watches_to_scrape = watch_list.load_watches(SCRAPE_FILE)
    browser = UriBrowser.new
    parser = ProductParser.new
    watches_to_scrape.each do |watch|
      begin
        puts "Model: #{watch.model} Brand: #{watch.brand} Count: #{count}"
        matching_url = url_matcher.find_url(watch)
        if matching_url
          retries ||= 0
          response = browser.get(matching_url)
          scrape_info = parser.parse_product_info(response)
          scrape_info["model"] = watch.model
          p scrape_info
          FileAccessor.push_to_file(OUTPUT_CSV_FILE, scrape_info.values)
        end
      rescue
        retry if (retries += 1) < 50
        puts "Error *** Count: #{count}"
      end
      count += 1
    end
    time_lapsed = (start_time - Time.now)/60
    puts "It took #{time_lapsed.to_i} minutes to complete"
    scraped_data = FileAccessor.parse_to_a(OUTPUT_CSV_FILE)
    Excel.new_file(scraped_data)
    binding.pry
    gmail = Gmail.connect(USER, PASSWORD)
      gmail.deliver do
        to RECEIVER
        subject "Joma Results"
        text_part {body "Attached is an excel sheet of recent scrape data #{time_lapsed.to_i}"}
        add_file OUTPUT_FILE
      end
    gmail.logout
  end
