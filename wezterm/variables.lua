local variables = {}

variables.callbacks = {}

function variables.callbacks.bgcolor(window, _, color)
	local overrides = window:get_config_overrides() or {}

	if color ~= "" then
		overrides.colors = { background = color }
	else
		overrides.colors = nil
	end

	window:set_config_overrides(overrides)
end

function variables.listen()
	local wezterm = require "wezterm"
	wezterm.on("user-var-changed", function(window,pane,name,value)
		if variables.callbacks[name] then
			return variables.callbacks[name](window, pane, value)
		end
	end)
end

return variables
