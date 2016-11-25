class Watch

	attr_reader :brand, :model

	def initialize(args)
		@brand = args.fetch("brand", "n/a")
		@model = args.fetch("model", "n/a")
	end

end