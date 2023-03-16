local M = {}

function M.get_char_ipair(str)
	local len = string.len(str)
	local index = 0

	return function()
		index = index + 1

		if index <= len then
			return index, string.sub(str, index, index)
		end
	end
end

return M
