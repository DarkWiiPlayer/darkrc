local stacc = require "stacc"

vim.api.nvim_create_user_command("Stacc", function(params)
	if params.args == "" then
		local count = #stacc.locations
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
	elseif params.args == "clear" then
		stacc.clear()
	elseif params.args == "pop" then
		local message, bufnr = stacc.pop(1)
		print(string.format("[%s] %s",
			vim.api.nvim_buf_get_name(bufnr):match("[^/]*$"),
			message
		))
	else
		stacc.push(params.args)
	end
end, {nargs="?"})
