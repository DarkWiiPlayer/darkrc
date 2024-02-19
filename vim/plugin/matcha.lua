local function nextcol(state)
	local from, to = state.str:find(state.pattern, state.last)
	if from then
		state.last = to+1
		return from, to
	end
end

local function colmatch(str, pattern)
	return nextcol, {str=str,pattern=pattern,last=0}
end

local function findLocations(args)
	local files = vim.fs.find(function(file)
		if #args>1 then
			for _, pattern in ipairs(args), args, 1 do
				if vim.fs.basename(file):find(pattern) then
					return true
				end
			end
		else
			return true
		end
		return false
	end, {
		limit=math.huge;
		type="file";
	})

	local locations = {}

	for _, file in ipairs(files) do
		local lnum = 0
		for line in io.lines(file) do
			lnum = lnum + 1
			for from, to in colmatch(line, args[1]) do
				table.insert(locations, {
					filename = file;
					lnum = lnum;
					col = from;
					end_col = to;
					text = line:sub(from, to)
				})
			end
		end
	end

	return locations
end

vim.api.nvim_create_user_command("Matcha", function(params)
	vim.fn.setqflist(findLocations(params.fargs))
	vim.cmd("copen")
	vim.cmd("crewind")
end, {nargs="+"})

vim.api.nvim_create_user_command("MatchaLocal", function(params)
	vim.fn.setloclist(0, findLocations(params.farts))
	vim.cmd("lopen")
	vim.cmd("lrewind")
end, {nargs="+"})
