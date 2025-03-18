local wezterm = require "wezterm"

require("variables").listen()

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font "Fira Code"

config.default_prog = { 'zsh', '--login' }
config.audible_bell = "Disabled"

local darkfile = os.getenv("HOME") .. "/.dark"

wezterm.add_to_config_reload_watch_list(darkfile)

if io.open(darkfile) then
	config.color_scheme = "lovelace"
else
	config.color_scheme = "Londontube (light) (terminal.sexy)"
end

local function recompute_window(window)
	local override = window:get_config_overrides() or {}

	local dimensions = window:get_dimensions()

	local padding
	if dimensions.is_full_screen then
		padding = math.min(dimensions.pixel_width, dimensions.pixel_height) * 0.05
	else
		padding = 10
	end
	override.window_padding = {
		left = padding,
		right = padding,
		top = padding,
		bottom = padding
	}

	window:set_config_overrides(override)
end

wezterm.on("window-resized", recompute_window)
wezterm.on("window-config-reload", recompute_window)

config.window_decorations = "TITLE | RESIZE"

config.keys = {
	{
		key = "d",
		mods = "ALT",
		action = wezterm.action.EmitEvent "toggle-window-decorations"
	};
}

wezterm.on("toggle-window-decorations", function(window)
	local override = window:get_config_overrides() or {}

	if override.window_decorations == "RESIZE" then
		override.window_decorations = "TITLE | RESIZE"
	else
		override.window_decorations = "RESIZE"
	end

	window:set_config_overrides(override)
end)

return config
