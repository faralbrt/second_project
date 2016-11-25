require 'csv'

module Csv

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
      converted_rows << row[0]
    end
    converted_rows
  end

  # def self.push_all_to_file(filename, array)
  #   array.each do |object|
  #     push_to_file(filename, object)
  #   end
  # end


  def self.push_to_file(filename, object)
    CSV.open(filename, "w") do |csv_row|
      csv_row << object
    end
  end



end