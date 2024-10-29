local Stacc = require "stacc"

local function staccmap()
	return setmetatable({}, {__index=function(self, key)
		self[key] = Stacc:new {}
		return self[key]
	end})
end

local windows = staccmap()
local buffers = staccmap()

local augroup = vim.api.nvim_create_augroup("stacc", {})

vim.api.nvim_create_autocmd({"WinClosed"}, {
	group = augroup;
	callback = function(arguments)
		windows[arguments.match] = nil
	end
})

local handler = function(params)
	local command = params.name

	local stacc if command:find("^G") then
		stacc = Stacc
	elseif command:find("^W") then
		stacc = windows[vim.fn.win_getid()]
	elseif command:find("^B") then
		stacc = buffers[vim.fn.bufnr()]
	else -- Default to per-window stack
		stacc = windows[vim.fn.win_getid()]
	end
	if params.args == "" then
		local count = #stacc.locations
		if count == 0 then
			print("Stacc is empty. Push with `:"..command.." description of current task`")
			print("Manipulate with :"..command.." pop|drop|clear")
		else
			for i, location in ipairs(stacc.locations) do
				local bufnr, id, description = unpack(location)
				--- @type number[]
				local mark = vim.api.nvim_buf_get_extmark_by_id(bufnr, stacc.namespace, id, {})
				print(string.format("%s %s:%i -- %s",
					string.format("%" .. math.floor(math.log(count, 10)+1) .. "i", i),
					vim.api.nvim_buf_get_name(bufnr):match("[^/]*$"),
					mark[1] + 1,
					description
				))
			end
		end
	elseif params.args == "drop" then
		stacc:drop(1)
	elseif params.args == "clear" then
		stacc:clear()
	elseif params.args == "pop" then
		local message, bufnr = stacc:pop(1)
		print(string.format("[%s] %s",
			vim.api.nvim_buf_get_name(bufnr):match("[^/]*$"),
			message
		))
	else
		stacc:push(params.args)
	end
end

vim.api.nvim_create_user_command("GStacc", handler, {nargs="?"})
vim.api.nvim_create_user_command("WStacc", handler, {nargs="?"})
vim.api.nvim_create_user_command("BStacc", handler, {nargs="?"})

vim.api.nvim_create_user_command("Stacc", handler, {nargs="?"})
