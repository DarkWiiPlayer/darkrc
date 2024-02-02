local snip = {
	snippets = {};
	ft = {};
}

function snip:new(name, filetype, snippet)
	if snippet==nil then
		return self:new(name, nil, filetype)
	end

	if type(snippet) ~= "table" then
		snippet = { snippet }
	end

	if filetype then
		if not self.ft[filetype] then
			self.ft[filetype] = {snippets = {}}
		end
		self.ft[filetype].snippets[name] = snippet
	else
		self.snippets[name] = snippet
	end
end

function snip:each(filetype)
	return coroutine.wrap(function()
		for name, snippet in pairs(snip.snippets) do
			coroutine.yield(name, snippet)
		end
		if filetype and snip.ft[filetype] then
			for name, snippet in pairs(snip.ft[filetype].snippets) do
				coroutine.yield(name, snippet)
			end
		end
	end)
end

function snip:get(name, filetype)
	local snippet = snip.snippets[name]
	if filetype and snip.ft[filetype] then
		snippet = snip.ft[filetype].snippets[name] or snippet
	end
	if snippet then
		return snippet
	end
end

local function complete(lead)
	local names = {}
	local known = {}
	for name, snippet in snip:each(vim.o.filetype) do
		if (name:find("^"..lead)) then
			if type(snippet)=="string"
			or snippet.condition == nil
			or snippet.condition() then
				if not known[name] then
					table.insert(names, name)
				end
				known[name] = true
			end
		end
	end
	table.sort(names)
	return names
end

local function process_item(item, lines)
	if type(item) == "string" then
		for _, line in ipairs(vim.fn.split(item, "\n")) do
			table.insert(lines, line)
		end
	elseif type(item) == "function" then
		process_item(item(), lines)
	else
		error("Unable to handle snippet item of type "..type(item))
	end
end

function snip:insert(name)
	local snippet = self:get(name, vim.o.filetype)

	if not snippet then
		print "No snippet with that name"
		return
	end

	local mode = snippet.mode or "l"

	local lines = {}

	for _, item in ipairs(snippet) do
		process_item(item, lines)
	end

	vim.api.nvim_put(lines, mode, true, true)
end

vim.api.nvim_create_user_command("Snip", function(params)
	snip:insert(params.args)
end, {nargs=1, complete=complete})

vim.api.nvim_create_user_command("Snips", function()
	local list = {}
	for name in snip:each(vim.o.filetype) do
		table.insert(list, name)
	end
	table.sort(list)
	print(table.concat(list, ", "))
end, {})

vim.api.nvim_create_user_command("SnipReload", function()
	package.loaded.snip = nil
	require "snip"
end, {})

return snip
