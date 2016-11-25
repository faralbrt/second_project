require_relative 'watch_list'
require_relative 'watch'
require_relative 'csv_module'
require_relative 'joma_watch'
require_relative 'joma_list'
require_relative 'Scraper'


scraper = JomaList.new("watches_urls.csv", "watches")
scraper.grab_urls
scraper.scrape

