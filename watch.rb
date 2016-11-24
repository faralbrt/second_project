class Watch

	attr_reader :brand, :model, :url

	def initialize(args)
		@brand = "citizen"
		@model = args.fetch("citizen", nil)
		@url = "http://www.jomashop.com/citizen-watch-#{@model.downcase}.html"
	end
end