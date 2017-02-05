class UrlMatcher

  def initialize(urls)
    @urls = urls
    @parsed_urls = Hash[parse_urls.map.with_index.to_a]
  end

  def find_url(watch)
    matches = find_matches(watch)
    return if matches == {}
    index = matches.values.first
    @urls[index]
  end


  private
  def parse_urls
    urls = @urls.dup
    urls.map! do |url|
      url = url.split('com/').last
      url.slice!('.html')
      url.delete!('-')
      url
    end
  end

  def find_matches(watch)
    model = keep_alphanumeric_chars(watch.model.split(' ').first)
    brand = keep_alphanumeric_chars(watch.brand)
    @parsed_urls.select do |parsed_url, index|
      matching_url?(model, brand, parsed_url)
    end
  end

  def matching_url?(model, brand, url)
    (url.end_with?(model) && url.include?(brand)) && (url.include?('openbox') == false)
  end

  def keep_alphanumeric_chars(str)
    str.gsub(/\W*/, "").downcase
  end

end
