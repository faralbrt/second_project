class Watch

	attr_reader :brand, :model

	def initialize(args)
		@brand = args.keys[0]
		@model = args.values[0]
	end

end