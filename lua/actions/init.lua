local nvim_util = require('actions.util.nvim')

local M = {}

function M.run()
	local test = nvim_util.get_pair_range()

	if not test then
		return
	end

	local line = vim.api.nvim_buf_get_lines(0, test[1][1] - 1, test[2][1], true)[1]
	local new_line = line:sub(1, test[1][2]) .. line:sub(test[2][2])
	vim.pretty_print(new_line)
	vim.api.nvim_buf_set_lines(0, test[1][1] - 1, test[2][1], true, { new_line })
	vim.api.nvim_win_set_cursor(0, { test[1][1], test[1][2] })
end

return M
