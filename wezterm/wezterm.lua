local wezterm = require "wezterm"

require("variables").listen()

local config = wezterm.config_builder()

config.hide_tab_bar_if_only_one_tab = true

local padding = 2
config.window_padding = {
	left = (padding * 1) .. "cell",
	right = (padding * 1) .. "cell",
	top = (padding * .4) .. "cell",
	bottom = (padding * .4) .. "cell"
}

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

return config
