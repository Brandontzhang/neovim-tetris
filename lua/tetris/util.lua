Util = {}
function Util.print2DTable(t)
	local prtStr = ""
	for _, row in pairs(t) do
		for _, val in pairs(row) do
			if val == " " then
				val = "="
			end
			prtStr = prtStr .. " " .. val .. " "
		end
		prtStr = prtStr .. "\n"
	end
	print(prtStr)
	print("------")
end

return Util
