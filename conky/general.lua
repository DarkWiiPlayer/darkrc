return [[$color3${time %Y-%m-%d}
$color1${voffset -10}${font Quicksand:size=40}${time %H:%M}$font$color
${color2}Uptime:$color $alignr$uptime
${color2}At Queue:$color $alignr${execi 2 atq | wc -l } Jobs
${color2}Due today:$color $alignr${execi 5 task "due <= eod +PENDING" export | luajit -e 'print(#require"cjson".decode(io.read("a")))' } Tasks
${color2}Due this week:$color $alignr${execi 5 task "due <= eow +PENDING" export | luajit -e 'print(#require"cjson".decode(io.read("a")))' } Tasks
#
${color3}Stats $hr$color
${color2}ip:$color $alignr${texeci 3 wget http://darkwiiplayer.com/api/ip --no-check-certificate -qO - 2>/dev/null }
${color2}vpn:$color $alignr${execi 2 expressvpn status | grep -Po 'Not connected|(?<=Connected to).*$'}
#
#${color3}Location $hr$color
#${color2}ip:$color $alignr${execi 2 ~/.bin/location}
#
${color3}Ping $hr
${color2}Google: $color$alignr${execi 2 timeout 1 ping google.de -c 1 | grep -Po '(?<=time=).*'}
${color2}Server: $color$alignr${execi 2 timeout 1 ping darkwiiplayer.com -c 1 | grep -Po '(?<=time=).*'}
#
${color3}CPU $hr
$color$cpu%$color2 CPU Usage
$color${cpubar 8}$color
${color2}Frequency:$color $alignr$freq_g GHz
#
${color3}Memory $hr$color
$color$memperc%${color2} RAM Usage
$color${membar 8}$color
$mem / $memmax
${color2}Processes:$color $processes  ${color2}Running:$color $running_processes
#
${color3}Storage $hr
${color2}root $alignr$color${fs_used /}/${fs_size /}
$color${fs_bar 8 /}
${color2}data $alignr$color${fs_used /data}/${fs_size /data}
$color${fs_bar 8 /data}
#
${color3}Networking $hr
${color2}Up:$color ${upspeed enp3s0} ${color2} - Down:$color ${downspeed enp3s0}
${font Hack:size=10}$color2$alignc${execi 1000 whoami}@${execi 1000 hostname}
]]
