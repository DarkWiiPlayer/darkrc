-- A simple per-session task stack.
-- Allows pushing locations with a note and returning to them later.

local ns = vim.api.nvim_create_namespace("stacc")

local locations = {}

local stacc = {}

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
function stacc.pop(count)
	if count > #locations then
		error("stack only has "..#locations.." elements.")
	end
	local description
	local final = vim.api.nvim_win_get_cursor(0)
	for _=1, count do
		local bufnr, id
		bufnr, id, description = unpack(table.remove(locations))
		final = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, id, {})
		vim.api.nvim_buf_del_extmark(bufnr, ns, id)
		final[1] = final[1] + 1 -- Make line 1-indexed
		final.bufnr = bufnr
	end
	vim.api.nvim_set_current_buf(final.bufnr or 0)
	final.bufnr = nil
	vim.api.nvim_win_set_cursor(0, final)
	return description
end

vim.api.nvim_create_user_command("StaccPush", function(params)
	stacc.push(params.args)
end, {nargs="?"})

vim.api.nvim_create_user_command("StaccPop", function(params)
	local message = stacc.pop(tonumber(params.args) or 1)
	print(message)
end, {nargs="?"})
