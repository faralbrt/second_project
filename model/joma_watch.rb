class JomaWatch

  attr_reader :brand, :model, :final_price, :availability, :shipping, :type_of_sale

  def initialize(args)
    @brand = args.fetch("brand", 'n/a')
    @model = args.fetch("model", 'n/a')
    @final_price = args.fetch("final_price", 'n/a')
    @availability = args.fetch("availability", 'n/a')
    @shipping = args.fetch("shipping", 'n/a')
    @type_of_sale = args.fetch("type_of_sale", 'n/a')
  end


end