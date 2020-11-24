local function opacity(value)
  os.execute(string.format(
    "xprop -id %s -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0x%xffffff",
    get_window_xid(), math.max(math.min(value, 255), 0)
  ))
end

local function rep(n, value)
  if n>0 then return value, rep(n-1, value) end
end

local margin = { rep(4, 16) }
if get_application_name():find("Thunderbird$") then
  print(get_window_name())
  if get_window_type():find("NORMAL$") then
    set_window_workspace(get_workspace_count())
    unmaximize()
    if get_window_name():find("Thunderbird$") then
      undecorate_window()
      set_window_geometry2(1680+margin[1], margin[2], 900-margin[1]-margin[3], 1440-margin[2]-margin[4])
    else
      set_window_geometry(1680+margin[1], margin[2], 900-margin[1]-margin[3], 1440-margin[2]-margin[4])
      set_window_fullscreen(true)
    end
    --maximize()
    opacity(230)
  end
end
