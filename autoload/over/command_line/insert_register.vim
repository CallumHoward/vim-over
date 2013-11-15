scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! over#command_line#insert_register#load()
	" load
endfunction


function! s:main()
	if over#command_line#is_input("\<C-r>")
		call over#command_line#setchar('"')
		call over#command_line#wait_keyinpu_on("InsertRegister")
		let s:old_line = over#command_line#getline()
		let s:old_pos  = over#command_line#getpos()
		return
	elseif over#command_line#get_wait_keyinput() == "InsertRegister"
		call over#command_line#setline(s:old_line)
		call over#command_line#setpos(s:old_pos)
		let key = over#command_line#keymap(over#command_line#char())
		if key =~ '^[0-9a-zA-z.%#:/"\-*=]$'
			execute "let regist = @" . key
			call over#command_line#setchar(regist)
		elseif key == "\<C-w>"
			call over#command_line#setchar(expand("<cword>"))
		elseif key == "\<C-a>"
			call over#command_line#setchar(expand("<cWORD>>"))
		elseif key == "\<C-f>"
			call over#command_line#setchar(expand("<cfile>"))
		elseif key == "\<C-r>"
			call over#command_line#setchar('"')
		endif
	endif
endfunction


function! s:on_OverCmdLineChar()
	if over#command_line#is_input("\<C-r>", "InsertRegister")
		call over#command_line#setpos(over#command_line#getpos()-1)
	else
		call over#command_line#wait_keyinpu_off("InsertRegister")
	endif
endfunction


augroup over-cmdline-insert_register
	autocmd!
	autocmd User OverCmdLineCharPre call s:main()
	autocmd User OverCmdLineChar call s:on_OverCmdLineChar()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo