local nvim_util = require('actions.util.nvim')

local M = {}

---Create a new line before the cursor. <esc>O is superior since it is indent
---aware
function M.create_line_above_with_indent()
	local window = 0

	local buffer = vim.api.nvim_win_get_buf(window)
	local cursor = vim.api.nvim_win_get_cursor(window)
	local prev_line = cursor[1] - 1
	local indent_string = nvim_util.get_current_indentation_string(window)

	vim.api.nvim_buf_set_lines(buffer, prev_line, prev_line, false, { indent_string })
	vim.api.nvim_win_set_cursor(window, { cursor[1], indent_string:len() })
end

---Deletes the current line
function M.delete_current_line()
	vim.api.nvim_del_current_line()
end

---Creates a duplicate of the current line below and move the cursor to exact
---column in the new line as of the current
function M.duplicate_current_line_below()
	local buffer = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local curr_line = vim.api.nvim_get_current_line()

	vim.api.nvim_buf_set_lines(buffer, cursor[1], cursor[1], true, { curr_line })
	vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, cursor[2] })
end

---Deletes text inside pair the cursor is in
function M.delete_inside_pair()
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
