do
	oldType = type
	export type = (v) -> 
		-- print "Type of #{v} = #{oldType v}"
		if oldType(v) == "table" and v.__class
			v.__class
		else
			oldType v

	export typeName = (v) ->
		if oldType(v) == "table" and v.__class and v.__class.__name
			v.__class.__name
		else
			oldType v