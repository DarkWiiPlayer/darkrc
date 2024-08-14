local wezvar = require "wezvar"

local termcolors = {}

local dark = {
	dayfox = "nightfox";
	antiphoton = "photon";
	fogbell_light = "fogbell";
}
local light = {}
for _light, _dark in pairs(dark) do
	light[_dark] = _light
end

function termcolors.propagate()
	local num_color = vim.fn.synIDattr(vim.fn.hlID("normal"), "bg")
	if vim.env.TERM_PROGRAM == "WezTerm" then
		wezvar("bgcolor", num_color)
	end
end

function termcolors.reset()
	if vim.env.TERM_PROGRAM == "WezTerm" then
		wezvar("bgcolor", "")
	end
end

vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Sets wezterm's background colour to match vim";
	callback = termcolors.propagate;
})

vim.api.nvim_create_autocmd("ExitPre", {
	desc = "Resets terminal colours back to normal";
	callback = termcolors.reset;
})

vim.api.nvim_create_user_command("Dark", function()
	if vim.o.bg ~= "dark" then
		local current_colors_name = vim.g.colors_name
		vim.g.ayucolor = "dark"
		vim.g.arcadia_Daybreak = nil
		vim.g.arcadia_Midnight = 1
		vim.g.alduin_Shout_Become_Ethereal = 1
		vim.o.bg = "dark"
		vim.cmd("colorscheme " .. (dark[current_colors_name] or current_colors_name))
	end
end, {})

vim.api.nvim_create_user_command("Light", function()
	if vim.o.bg ~= "light" then
		local current_colors_name = vim.g.colors_name
		vim.g.ayucolor = "light"
		vim.g.arcadia_Daybreak = 1
		vim.g.arcadia_Midnight = nil
		vim.g.alduin_Shout_Become_Ethereal = nil
		vim.o.bg = "light"
		vim.cmd("colorscheme " .. (light[current_colors_name] or current_colors_name))
	end
end, {})

vim.cmd("colorscheme nord")
if vim.fn.filereadable(os.getenv("HOME") .. "/.dark")==1 then
	vim.cmd("Dark")
else
	vim.cmd("Light")
end

-- Reset background color to match terminal
vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
