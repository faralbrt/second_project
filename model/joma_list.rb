require_relative 'Scraper'

class JomaList

  attr_accessor :available_urls, :joma_watches, :filename

  include Scraper

  def initialize(filename, category)
    @joma_watches = []
    @available_urls = []
    @filename = filename
    @category = category
  end

  def grab_urls
    if File.exists?(@filename)
      Csv.parse_to_a(@filename).each do |url|
        @available_urls << url
      end
    else
      puts "no file found"
    end
  end

  def scrape
    scrape_watches
  end

  def push_results

  end

end