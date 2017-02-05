require 'nokogiri'

class ProductParser
  def parse_product_info(page)
    @page = Nokogiri::HTML.parse(page)
      {"brand"        => brand,
       "joma_model"   => joma_model,
       "final_price"  => final_price,
       "availability" => availability,
       "shipping"     => shipping,
       "type_of_sale" => type_of_sale}
  end

  private
  def brand
    at_css('span#Brand.data')
  end

  def joma_model
    at_css('span#Model.data')
  end

  def type_of_sale
    at_css('span.doorbuster-price')
  end

  def final_price
    at_css('span#final-price')
  end

  def availability
    section = @page.css('span.pdp-shipping-availability')
    section.children.children[1].text.strip
  end

  def shipping
    section = @page.css('span.pdp-shipping-availability')
    section.children.children[2].text.strip
  end


  def at_css(selector)
    object = @page.css(selector)
    object.text.strip if object
  end
end
