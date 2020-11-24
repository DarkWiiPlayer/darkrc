local config = {
	monitor = 1,
	double_buffer = true,
	update_interval = 1,
	alignment = 'bottom_right',
	gap_x = 00-1920 --[[100 + 320]],
	gap_y = 00 --[[100 + 200]],
	own_window = true,
	own_window_title = 'conky',
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	own_window_argb_visual = true,
	own_window_transparent = true,
	own_window_argb_value = 255,
	border_inner_margin = 8,
--	background = true,
	border_width = 1,
	cpu_avg_samples = 2,
	draw_borders = false,
	draw_graph_borders = true,
	draw_outline = false,
	draw_shades = false,
	use_xft = true,
	font = 'Quicksand:size=14',
	minimum_height = 5,
	minimum_width = 250,
	net_avg_samples = 2,
	no_buffers = false,
	out_to_console = false,
	out_to_stderr = false,
	extra_newline = false,
	stippled_borders = 0,
	uppercase = false,
	use_spacer = 'none',
	show_graph_scale = false,
	show_graph_range = false,
}

local dark = io.open(os.getenv("HOME").."/.dark")

if dark then
	config.default_color = '#ffffff'
	config.color1 = "#ffffff"
	config.color2 = "#aaaaaa"
	config.color3 = "#df74b1"
else
	config.default_color = '#525564'
	config.color1 = "#494c5b"
	config.color2 = "#333333"
	config.color3 = "#fb006b"
end

return config
