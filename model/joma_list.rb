require_relative 'Scraper'

class JomaList

include Scraper

  def initialize(brand)
    @joma_watches = []
    @available_urls = []
    @brand = brand
  end

  def grab_urls
    filename = "#{@brand}_urls.csv"
    if File.exists?(filename)
      Csv.parse_to_a(filename).each do |url|
        @available_urls << url
      end
    else
      scrape_urls(@brand)
      Csv.push_all_to_file(filename, @available_urls)
    end
  end

  def scrape(watches)
    watches.each do |watch|
      result = Scraper.scrape_product(watch.model)  

    end
  end

  def push_results

  end

end