require 'csv'

module CsvParser
  def self.parse(filename)
    converted_rows = []
    CSV.foreach(filename, :headers => true) do |row|
      converted_rows << row.to_hash
    end
    converted_rows
  end
end