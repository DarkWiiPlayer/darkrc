-- A simple per-session task stack.
-- Allows pushing locations with a note and returning to them later.

--- @type number Namespace id for the plugin
local ns = vim.api.nvim_create_namespace("stacc")

--- @class Location
--- @field [1] number Buffer Number
--- @field [2] number ExtMark ID
--- @field [3] string Description
--- @field [4] number Current line number

--- @class stacc
--- @field locations Location[] Array listing all the locations with newest ones having the highest indices
--- @field namespace number Namespace ID used for ExtMarks
local stacc = {
	locations = {};
	namespace = ns;
}
stacc.__index = stacc

--- Pushes a new location to the stack
--- @param description string A message to display when returning to this location
function stacc:push(description)
	local bufnr = vim.fn.bufnr()
	local line, column = unpack(vim.api.nvim_win_get_cursor(0))
	line = line - 1 -- 0-based :help api-indexing
	local id = vim.api.nvim_buf_set_extmark(bufnr, ns, line, column, {})
	table.insert(self.locations, {bufnr, id, description, vim.fn.line(".")})
end

--- Silently pops/drops a given number of items from the task stack
--- @param count number How many items to drop from the stack
--- @return string description The description of the current task
--- @return number bufnr Buffer number of the stack entry
--- @return number row Line number (1-indexed)
--- @return number col Column number (1-indexed)
function stacc:drop(count)
	if count > #self.locations then
		error("stack only has "..#self.locations.." elements.")
	end
	local bufnr, description
	local final = vim.api.nvim_win_get_cursor(0)
	for _=1, count do
		local id
		bufnr, id, description = unpack(table.remove(self.locations))
		final = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, id, {})
		vim.api.nvim_buf_del_extmark(bufnr, ns, id)
		final[1] = final[1] + 1 -- Make line 1-indexed
		final[2] = final[2] + 1 -- Make column 1-indexed
	end
	return description, bufnr, final[1], final[2]
end

--- Pops a given number of items from the task stack
--- Jumps to the last removed item and displays its description
--- @param count number How many items to pop from the stack
--- @return string description The description of the current task
--- @return number bufnr Buffer number of the stack entry
--- @return number row Line number (1-indexed)
--- @return number col Column number (1-indexed)
function stacc:pop(count)
	if count > #self.locations then
		error("stack only has "..#self.locations.." elements.")
	end
	local bufnr, description
	local final = vim.api.nvim_win_get_cursor(0)
	for _=1, count do
		local id
		bufnr, id, description = unpack(table.remove(self.locations))
		final = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, id, {})
		vim.api.nvim_buf_del_extmark(bufnr, ns, id)
		final[1] = final[1] + 1 -- Make line 1-indexed
		final[2] = final[2] + 1 -- Make column 1-indexed
		final.bufnr = bufnr
	end
	vim.api.nvim_set_current_buf(final.bufnr or 0)
	final.bufnr = nil
	vim.api.nvim_win_set_cursor(0, final)
	return description, bufnr, final[1], final[2]
end

--- Clears the entire stack
function stacc:clear()
	self:pop(#self.locations)
end

--- @return Stacc new
function stacc:new(new)
	new = new or {}
	new.locations = new.locations or {}
	return setmetatable(new, self)
end

return stacc
