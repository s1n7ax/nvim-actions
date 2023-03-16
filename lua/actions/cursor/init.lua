local nvim_util = require('actions.util.nvim')

local M = {}

---Jumps to the start of the line
---@param window number? Window id
function M.jump_to_line_start(window)
	window = window or 0

	local cursor = vim.api.nvim_win_get_cursor(window)
	vim.api.nvim_win_set_cursor(window, { cursor[1], 0 })
end

---Jumps to the first non white space character
---@param window number? Id of the window
function M.jump_to_first_non_white_space_char(window)
	window = window or 0

	local cursor = vim.api.nvim_win_get_cursor(window)
	local indent_size = nvim_util.get_current_indentation_size(window)
	vim.api.nvim_win_set_cursor(window, { cursor[1], indent_size })
end

return M
