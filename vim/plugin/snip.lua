require "snip"
for _, path in ipairs(vim.api.nvim__get_runtime({"snip/snippets.lua"}, true, {})) do
	local code = io.open(path):read("*a")
	if code then
		dofile(path)
	end
end
