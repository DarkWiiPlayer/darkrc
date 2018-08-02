-- vim: set noexpandtab :miv --
tree = (tab, pref='') ->
	print tab.title and tab.title or '┐'

	for idx, element in ipairs tab
		last = idx == #tab
		first = idx == 1
		io.write pref
		io.write last and "└─" or "├─"
		switch type element
			when "table"
				tree element, pref .. (last and '  ' or '│ ')
			else
				print tostring element

import max from math
column = (col) ->
	if type(col)!="table" then col = {col}
	pad = (str, len) ->
		str..string.rep(" ", len-#str)
	width = 0
	for box in *col
		if type(box)!="table" then box = {box}
		for elem in *box
			width = max(width, #elem)

	print "┌─"..string.rep("─",width).."─┐"
	for idx,box in ipairs(col)
		if type(box)!="table" then box={box}
		last = idx==#col
		for elem in *box
			io.write "│ "
			io.write pad elem, width
			io.write " │"
			print!
		unless last
			print "├─"..string.rep("─",width).."─┤"
	print "└─"..string.rep("─",width).."─┘"

box = (box) ->
	column { box }

CLASS = [[
print vim.col {
	{ 'Class' } -- Title
	{
		-- Members
	}
	{
		-- Methods
	}
}
]]

draw = ->
	for line in * {
		{ "─", "│", "┼" }
		{ "┌", "┐", "└", "┘" }
		{ "├", "┤", "┬", "┴" }
    { "╼", "╽", "╾", "╾" }
	}
		print table.concat(line, " ")


{
	:tree, :column, :box, :draw, :CLASS
	-- Aliases
	col: column
}
