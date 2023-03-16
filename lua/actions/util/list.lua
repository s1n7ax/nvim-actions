local M = {}

---Returns true if the predicate returns true for every element in the list
---@param list any[] list of items to check the predicate against
---@param predicate function function that takes an element and returns boolean
---@returns boolean
function M.every(list, predicate)
	for _, value in ipairs(list) do
		if not predicate(value) then
			return false
		end
	end

	return true
end

---Returns true if the predicate returns true for any element in the list
---@param list any[] list of items to check the predicate against
---@param predicate function function that takes an element and returns boolean
---@returns boolean
function M.some(list, predicate)
	for _, value in ipairs(list) do
		if predicate(value) then
			return true
		end
	end

	return false
end

---Returns the index of the element that contains the matching value
---@param list any[] list of values
---@param value any value to the index of
---@returns number index of the value
function M.index_of(list, value)
	for index, element in ipairs(list) do
		if value == element then
			return index
		end
	end
end

---Returns the index if the predicate returns true
---@param list any[] list of items
---@param predicate function predicate to find the index of the value
function M.index_of_by_predicate(list, predicate)
	for index, element in ipairs(list) do
		if predicate(element) then
			return index
		end
	end
end

return M
