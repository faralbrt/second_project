require 'watir'

class WatirBrowser
  attr_reader :browser

  def initialize
    @browser = Watir::Browser.new(:firefox)
  end

  def get(url)
    browser.goto(url)
    browser.html
  end

end
