---------------------------------------------------------
--- Extended string library for luvit.
---------------------------------------------------------

return function(string)

	string.split = function(inputstr, sep)
		if sep == nil then
			sep = "%s"
    end

    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    	t[i] = str
      i = i + 1
    end
    return t
	end

end
