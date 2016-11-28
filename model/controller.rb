require_relative 'scraper_module'
require_relative 'csv_module'

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
  end

end