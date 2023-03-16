local str_util = require('actions.util.string')

local M = {}

function M.get_current_indentation_size(window)
	local buffer = vim.api.nvim_win_get_buf(window)
	local cursor = vim.api.nvim_win_get_cursor(window)
	local curr_line = vim.api.nvim_buf_get_lines(buffer, cursor[1] - 1, cursor[1], true)
	local _, white_space_end = curr_line[1]:find('^%s+')

	-- white_space_end is nil when there is not indentation hens the 'or 0'
	return white_space_end or 0
end

function M.get_current_indentation_string(window)
	local buffer = vim.api.nvim_win_get_buf(window)
	local cursor = vim.api.nvim_win_get_cursor(window)
	local curr_line = vim.api.nvim_buf_get_lines(buffer, cursor[1] - 1, cursor[1], true)
	local white_space_start, white_space_end = curr_line[1]:find('^%s+')

	-- when there is no white space, the start and end is nil
	if not white_space_start then
		return ''
	end

	return curr_line[1]:sub(white_space_start, white_space_end)
end

---Returns the range of a pair chars
---Following chars are considered a pair
---{} [] () "" '' ``
---
---This is how the function is figuring out the range of closest pair
---2) Starts finding starting pair from the beginning of the line and go until cursor column
---3) Memorize the starting tags from the beginning of the line to the cursor
---4) IF the starting tag is being closed before the cursor, then the pair can be ignored
---		* IF the last item in the stack is similar to starting pair THEN remove
---		the item from the stack and move on to the next char
---		* IF the starting pair is a match then capture the char as well as the
--		starting position
---5) Gets the closest starting pair character. This will be the target of the action
---6) Finds the closing position in the current line or lines below
---7) IF no pairs found until the cursor, continues to find starting starting pair
---until the end of the line
---8) IF nothing found, return nil
function M.get_pair_range(pairs)
	pairs = pairs
		or {
			{ '"', '"' },
			{ "'", "'" },
			{ '`', '`' },
			{ '(', ')' },
			{ '{', '}' },
			{ '[', ']' },
			{ '<', '>' },
		}

	local window = 0
	local cursor = vim.api.nvim_win_get_cursor(window)
	local curr_line = vim.api.nvim_get_current_line()
	local left_text = curr_line:sub(1, cursor[2])
	local right_text = curr_line:sub(cursor[2] + 1, #curr_line)

	local pair_stack = {}

	-- start from start of the line to cursor position
	for index, char in str_util.get_char_ipair(left_text) do
		for _, pair in ipairs(pairs) do
			local starting_pair = pair[1]
			local ending_pair = pair[2]

			if char == ending_pair and pair_stack[#pair_stack].pair[1] == starting_pair then
				table.remove(pair_stack, #pair_stack)
				goto next_letter
			end

			if char == starting_pair then
				table.insert(pair_stack, {
					pair = pair,
					pos = { cursor[1], index },
				})
				goto next_letter
			end
		end

		::next_letter::
	end

	if #pair_stack < 1 then
		return
	end

	for index, char in str_util.get_char_ipair(right_text) do
		local ending_pair = pair_stack[#pair_stack].pair[2]
		if char == ending_pair then
			return {
				pair_stack[#pair_stack].pos,
				{ cursor[1], cursor[2] + index },
			}
		end
	end
end

function M.lines_ipair(buffer, line_start, line_end)
	local line_count = vim.fn.line('$')
	local index = line_start

	return function()
		index = index + 1

		if index <= line_end and index <= line_count then
			return vim.api.nvim_buf_get_lines(buffer, index, index)[1]
		end
	end
end

return M
