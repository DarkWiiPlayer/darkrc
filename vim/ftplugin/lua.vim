setlocal makeprg=luacheck\ --formatter=plain
setlocal textwidth=120
let b:undo_ftplugin = "setlocal makeprg= | setlocal textwidth="
