return [=====[
${execi 1 playerctl metadata xesam:artist | sed 's/-/—/'}
${font Quicksand:size=20}${execi 1 playerctl metadata xesam:title | sed 's/-/—/'}${font}
${alignr}${execi 1 playerctl status}
]=====]
