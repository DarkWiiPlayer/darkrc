return [[
${offset 10}${font Quicksand:size=40}${time %H:%M}${alignr}${font Quicksand:size=20}${execi 300 curl 'wttr.in/falkenstein%20(vogtland)?format=%t%20/%20%f' }${font}
$color3${hr}
${alignr}${font Quicksand:size=20}$color2${time %A} ${time %d.%m.%Y}$color
]]
