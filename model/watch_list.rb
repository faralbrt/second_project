class WatchList
  attr_reader :watches

  def initialize
    @watches = []
  end

  def load_watches(filename)
    watches_arr = FileAccessor.parse_to_hash(filename)

    watches_arr.each do |watch|
      watches << Watch.new(watch)
    end
    watches
  end

end
