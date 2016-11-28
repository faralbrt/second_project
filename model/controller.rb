require_relative 'scraper_module'
require_relative 'csv_module'
require_relative 'watch'
require_relative 'watch_list'

# browser is set to start up in firefox using the compatible geckodriver.exe which is placed in the current path

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
    FileAccessor.overwrite_all('all_urls.csv', url_list)
    browser.close
  when "scrape"
    count = 1
    scrape_file = options.first
    url_list = FileAccessor.parse_to_a('all_urls.csv')
    watch_list = WatchList.new
    watches_to_scrape = watch_list.load_watches(scrape_file)
    watches_to_scrape.each do |watch|
      matching_url = Scraper.match_to_url(watch, url_list)
      if matching_url
        scrape_info = Scraper.scrape_watch(browser, matching_url)
        scrape_info["model"] = watch.model
        p scrape_info
        FileAccessor.push_to_file('jomashop_results.csv', scrape_info.values)
        count += 1
        puts "Count - #{count}"
      end
    end
  end

end