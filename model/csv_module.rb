require 'csv'

module FileAccessor

  def self.parse_to_hash(filename)
    converted_rows = []
    CSV.foreach(filename, :headers => true) do |row|
      converted_rows << row.to_hash
    end
    converted_rows
  end

  def self.parse_to_a(filename)
    converted_rows = []
    CSV.foreach(filename) do |row|
      converted_rows << row
    end
    converted_rows
  end

  def self.push_to_file(filename, object)
    CSV.open(filename, "a") do |csv_row|
      csv_row << object
    end
  end

  def self.overwrite_all(filename, arr)
    CSV.open(filename, "w") do |csv_row|
      arr.each do |str|
        csv_row << [str]
      end
    end
  end

  def self.clear_file(filename)
    CSV.open(filename, "w") do |csv_row|
      csv_row << %w{title joma_model final_price availability shipping type_of_sale model}
    end
  end


end
