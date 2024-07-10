-- A simple per-session task stack.
-- Allows pushing locations with a note and returning to them later.

--- @type number Namespace id for the plugin
local ns = vim.api.nvim_create_namespace("stacc")

local locations = {}

--- @class Location
--- @field [1] number Buffer Number
--- @field [2] number ExtMark ID
--- @field [3] string Description
--- @field [4] number Current line number

--- @class stacc
--- @field locations Location[] Array listing all the locations with newest ones having the highest indices
--- @field namespace number Namespace ID used for ExtMarks
local stacc = {
	locations = locations;
	namespace = ns;
}

--- Pushes a new location to the stack
--- @param description string A message to display when returning to this location
function stacc.push(description)
	local bufnr = vim.fn.bufnr()
	local line, column = unpack(vim.api.nvim_win_get_cursor(0))
	line = line - 1 -- 0-based :help api-indexing
	local id = vim.api.nvim_buf_set_extmark(bufnr, ns, line, column, {})
	table.insert(locations, {bufnr, id, description, vim.fn.line(".")})
end

--- Pops a given number of items from the task stack
--- Jumps to the last removed item and displays its description
--- @param count number How many items to pop from the stack
--- @return string description The description of the current task
--- @return number bufnr Buffer number of the stack entry
--- @return number row Line number (1-indexed)
--- @return number col Column number (1-indexed)
function stacc.pop(count)
	if count > #locations then
		error("stack only has "..#locations.." elements.")
	end
	local bufnr, description
	local final = vim.api.nvim_win_get_cursor(0)
	for _=1, count do
		local id
		bufnr, id, description = unpack(table.remove(locations))
		final = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, id, {})
		vim.api.nvim_buf_del_extmark(bufnr, ns, id)
		final[1] = final[1] + 1 -- Make line 1-indexed
		final[2] = final[2] + 1 -- Make column 1-indexed
		final.bufnr = bufnr
	end
	vim.api.nvim_set_current_buf(final.bufnr or 0)
	final.bufnr = nil
	vim.api.nvim_win_set_cursor(0, final)
	return description, bufnr, unpack(final)
end

--- Clears the entire stack
function stacc.clear()
	stacc.pop(#locations)
end

return stacc
