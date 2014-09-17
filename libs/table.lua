---------------------------------------------------------
--- Extended table library for luvit.
---------------------------------------------------------

return function(table)

	table.find = function(t, v)
		for k,v1 in pairs(t) do
			if v1 == v then
				return k
			end
		end
		return nil
	end

	table.reverse = function( tab )
		local size = #tab
		local newTable = {}

		for i,v in ipairs ( tab ) do
			newTable[size-i] = v
		end

		return newTable
	end

	table.invert = function( tab )
		local newTable = {}

		for k,v in pairs ( tab ) do
			newTable[v] = k
		end

		return newTable
	end

end
