local function nextcol(state)
	local from, to
	if type(state.pattern) == "string" then
		from, to = state.str:find(state.pattern, state.last)
	else
		if state.last == 0 then
			from, to = state.pattern:match_str(state.str)
			if from then from = from + 1 end
		end
	end
	if from then
		state.last = to+1
		return from, to
	end
end

local function isfile(path)
	return vim.fn.isdirectory(path) == 0
end

local function colmatch(str, pattern)
	return nextcol, {str=str,pattern=pattern,last=0}
end

local function findFiles(...)
	local paths if ... then
		paths = {}
		for _, glob in ipairs { ... } do
			for _, path in ipairs(vim.fn.glob(glob, false, true)) do
				if isfile(path) then
					-- Assume overhead of table.insert is outweighed by all the file ops anyway
					table.insert(paths, path)
				end
			end
		end
	else
		paths = vim.fn.argv()
	end

	return paths
end

local function findLocations(pattern, files, regex)
	local locations = {}

	if regex then
		pattern = vim.regex(pattern)
	end

	for _, file in ipairs(files) do
		local lnum = 0
		for line in io.lines(file) do
			lnum = lnum + 1
			for from, to in colmatch(line, pattern) do
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

local parse_args do
	if pcall(require, "arrr") then
		local arrr = require "arrr"

		parse_args = arrr {
			{ "Use location list instead of quickfix list", "--location-list", "-l" };
			{ "Appends to the current quicklist", "--append", "-a" };
			{ "Replaces the current quicklist", "--replace", "-r" };
			{ "Use vim regular expressions instead of patterns", "--vim-regex", "-v" };
		}
	else
		function parse_args(args)
			return args
		end
	end
end


vim.api.nvim_create_user_command("Matcha", function(params)
	local args = parse_args(params.fargs)
	local files = findFiles(unpack(args, 2))

	local locations = findLocations(args[1], files, args.vimregex)

	if not locations[1] then return print("Nothing found") end

	local action if args.append then
		action = "a"
	elseif args.replace then
		action = "u"
	else
		action = " "
	end

	local what = { title = string.format("Matcha: `%s`", args[1]), items = locations }

	if args.locationlist then
		vim.fn.setloclist(0, {}, action, what)
		vim.cmd("lopen")
		vim.cmd("lrewind")
	else
		vim.fn.setqflist({}, action, what)
		vim.cmd("copen")
		vim.cmd("crewind")
	end
end, {nargs="+"})
