require 'spreadsheet'

module Excel
  @file = '../files/results.xls'
  @headers = %w{title joma_model final_price availability shipping type_of_sale model}
  @seed_data = [["hello"], ["the name is"], ["Albert"]]

  def self.new_file(data = @seed_data)
    File.delete(@file)
    book = Spreadsheet::Workbook.new
    book.create_worksheet :name => 'results'
    sheet = book.worksheet 0
    sheet.row(0).concat @headers
    self.load_data(sheet, data)
    book.write(@file)
  end

  def self.load_data(sheet, data)
    row_count = 1
    data.each do |seed_row|
      sheet.row(row_count).concat seed_row
      row_count += 1
    end
  end

end
