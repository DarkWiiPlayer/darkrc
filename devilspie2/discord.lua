local function opacity(opacity)
	os.execute(string.format(
		"xprop -id %s -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0x%xffffff",
		get_window_xid(), math.max(math.min(opacity, 255), 0)
	))
end

if get_application_name():find "Discord$" then
	unmaximize()
	undecorate_window()
	maximize()
	set_window_workspace(get_workspace_count())
end
