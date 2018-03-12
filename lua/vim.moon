-- vim: set noexpandtab :miv --
tree = (tab, level=0, skip="") ->
	if level==0
		print "┐"

	pre = (lvl, skip) ->
		for i=1,lvl
			if skip\sub(i,i) == "y"
				io.write "	"
			else
				io.write "│ "

	for idx, element in ipairs tab
		last = idx == #tab
		switch type element
			when "table"
				pre level, skip
				io.write last and "└─" or "├─"
				print element.title and "┬─ "..element.title or "┐"
				tree element, level+1, skip .. (last and "y" or "n")
			else
				pre level, skip
				if idx<#tab
					print "├─ "..element
				else
					print "└─ "..element

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

draw = ->
	for line in * {
		{ "─", "│", "┼" }
		{ "┌", "┐", "└", "┘" }
		{"├", "┤", "┬", "┴"}
	}
		print table.concat(line, " ")


{
	:tree, :column, :box, :draw
	-- Aliases
	col: column
}
