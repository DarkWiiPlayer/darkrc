-- vim: set noexpandtab :miv --

-- ┌──────────────────────────┐
-- │ Generic Helper Functions │
-- └──────────────────────────┘

match_all = (str, pat, init=0) ->
	s,e = str\find(pat, init)
	if s then
		return str\sub(s,e), match_all(str, pat, e+1)
match_lines = (str) -> match_all(str, '[^\n]+')

-- ┌──────────────────┐
-- │ Actual Functions │
-- └──────────────────┘

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

pad = (str='', len) ->
	str..string.rep(" ", len-#str)

import max from math

chktbl = (obj) -> error("Object is not a table", 2) if type(obj) ~= 'table'
to_tab = (obj) -> type(obj)=='table' and obj or {match_lines tostring obj}

tab = (rows) ->
	-- Get Measurements
	chktbl(rows)
	width = {}
	height = {}
	for row, fields in ipairs rows
		chktbl(fields)
		height[row] = 1
		for col, lines in ipairs fields
			lines = to_tab lines
			height[row] = max(height[row], #lines)
			for line in *lines do
				width[col] = max(width[col] or 1, #line)
			fields[col] = lines
	bars = [string.rep('─', i+2) for i in *width]
	-- Top Line
	print '┌'..table.concat(bars, '┬')..'┐'
	-- Rows
	for row, fields in ipairs rows
		for line=1,height[row]
			io.write '│' -- Outer Left Border
			for col, lines in ipairs fields
				io.write ' '..pad(lines[line], width[col])..' '
				io.write '│' if col < #fields
			print '│' -- Outer Left Border
		print '├'..table.concat(bars, '┼')..'┤' unless row == #rows
	print '└'..table.concat(bars, '┴')..'┘'

col = (col) -> tab([{elem} for elem in *col])
row = (row) -> tab{row}
box = (box) -> tab{{box}}

line = (len=80) -> print string.rep('─', len)
line2 = (len=80) ->
	error('Length must be at least 2 characters', 2) if len < 2
	print '┌'..string.rep('─', len-2)..'┐'
	print '└'..string.rep('─', len-2)..'┘'

{
	:tree, :box, :tab, :col, :row, :line, :line2
	-- Aliases
	table: tab
}
