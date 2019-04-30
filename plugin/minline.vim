" A minimal Vim statusline with support for Ale and vim-fugitive
"
" URL:          github.com/mgutz/minline
" License:      MIT (https://opensource.org/licenses/MIT)

" vim gotchas: 0 == ''

if exists("g:loaded_minline")
	finish
endif
let g:loaded_minline = 1

" By default don't display Git branches using the U+E0A0 branch character.
let g:minlineWithGitBranchCharacter = get(g:, "minlineWithGitBranchCharacter", 0)

" By default always use minline colors and ignore any user-defined colors.
let g:minlineHonorUserDefinedColors = get(g:, "minlineHonorUserDefinedColors", 0)

" let s:modes = {
"   \  "n":      ["%0*", " normal "],
"   \  "i":      ["%1*", " insert "],
"   \  "R":      ["%4*", " r-mode "],
"   \  "v":      ["%3*", " visual "],
"   \  "V":      ["%3*", " v-line "],
"   \  "\<C-v>": ["%3*", " v-rect "],
"   \  "c":      ["%1*", " c-mode "],
"   \  "s":      ["%3*", " select "],
"   \  "S":      ["%3*", " s-line "],
"   \  "\<C-s>": ["%3*", " s-rect "],
"   \  "t":      ["%1*", " term "],
"   \}

" keyboard symbol
" ⌨
" pencil up
" ✐
let s:modes = {
			\  "n":      ["%#MinlineNormalMode#", "✜" ],
			\  "i":      ["%1*", "i"],
			\  "R":      ["%4*", "R"],
			\  "v":      ["%3*", "v"],
			\  "V":      ["%3*", "V"],
			\  "\<C-v>": ["%3*", "^v"],
			\  "c":      ["%1*", "c"],
			\  "s":      ["%3*", "s"],
			\  "S":      ["%3*", "S"],
			\  "\<C-s>": ["%3*", "^s"],
			\  "t":      ["%1*", "t"],
			\}


" The minline colors (https://github.com/bluz71/vim-minline-colors)
let s:white   = "#c6c6c6" " white   = 251
let s:grey236 = "#303030" " grey236 = 236
let s:grey234 = "#1c1c1c" " grey234 = 234
let s:emerald = "#42cf89" " emerald = 10
let s:blue    = "#80a0ff" " blue    = 4
let s:purple  = "#ae81ff" " purple  = 13
let s:crimson = "#f74782" " crimson = 9

function! MinlineModeColor(mode)
	return get(s:modes, a:mode, "%*1")[0]
endfunction

function! MinlineModeText(mode)
	return get(s:modes, a:mode, " normal ")[1]
endfunction

function! MinlineUserColor(num, text)
	return '%' . a:num . '*' . a:text . '%*'
endfunction


function! s:getHighlightTerm(group, term)
	" Store output of group to variable
	let output = execute('hi ' . a:group)

	if output =~ a:term
		" Find the term we're looking for
		return matchstr(output, a:term.'=\zs\S*')
	endif
	return ''
endfunction

function! s:reverse(group)
	" Store output of group to variable
	let output = execute('hi ' . a:group)

	if output =~ a:term
		" Find the term we're looking for
		return matchstr(output, a:term.'=\zs\S*')
	endif
	return ''
endfunction

function! s:HighlightGroup(group_name, ctermfg, ctermbg)
	let l:ctermfg = ''
	if a:ctermfg != ''
		let l:ctermfg = ' ctermfg=' . a:ctermfg
	endif

	let l:ctermbg = ''
	if a:ctermbg != ''
		let l:ctermbg = ' ctermbg=' . a:ctermbg
	endif

    if l:ctermfg == '' && l:ctermbg == ''
        return ''
    endif

	let l:highlight = 'highlight ' . a:group_name . l:ctermfg . l:ctermbg
	return l:highlight
endfunction


function! s:ExecHighlightGroup(group_name, ctermfg, ctermbg)
	let l:hg = s:HighlightGroup(a:group_name, a:ctermfg, a:ctermbg)
    if l:hg == ''
        let l:hg = s:HighlightGroup(a:group_name, 'none', 'none')
    endif

    exec l:hg
endfunction

let s:reset = '%0*'
let s:specialColor = '%#MinlineSpecial#'
let s:vbar = s:specialColor . '│' . s:reset
let s:middot =  s:specialColor . '·' . s:reset
let s:separator =  s:specialColor . ' │ ' . s:reset

function! s:ColorScheme()
	if g:minlineHonorUserDefinedColors
		return
	endif


	let l:ctermbg = s:getHighlightTerm('StatusLine', 'ctermbg')
	let l:ctermfg = s:getHighlightTerm('StatusLine', 'ctermfg')


	" Set FG only and use existing StatusLine BG
	call s:ExecHighlightGroup('MinlineError', '1', l:ctermbg)
	call s:ExecHighlightGroup('MinlineWarning', '3', l:ctermbg)
	call s:ExecHighlightGroup('MinlineSpecial', '0', l:ctermbg)
	call s:ExecHighlightGroup('MinlineNormalMode', l:ctermbg, l:ctermfg)
	call s:ExecHighlightGroup('MinlineReverse', l:ctermbg, l:ctermfg)

	exec "highlight User1 ctermbg=4   guibg=" . s:blue    . " ctermfg=234 guifg=" . s:grey234
	exec "highlight User2 ctermbg=251 guibg=" . s:white   . " ctermfg=234 guifg=" . s:grey234
	exec "highlight User3 ctermbg=13  guibg=" . s:purple  . " ctermfg=234 guifg=" . s:grey234
	exec "highlight User4 ctermbg=9   guibg=" . s:crimson . " ctermfg=234 guifg=" . s:grey234
	exec "highlight User5 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10  guifg=" . s:emerald . " gui=none"
	exec "highlight User6 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
	exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
	exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=9   guifg=" . s:crimson . " gui=none"
endfunction


function! MinlineFugitiveBranch()
	if !exists("g:loaded_fugitive") || !exists("b:git_dir")
		return ""
	endif

	if g:minlineWithGitBranchCharacter
		return s:specialColor . "" . s:reset . fugitive#head()
	endif
	return fugitive#head()
endfunction

function! MinlineShortFilePath()
	if &buftype == "terminal"
		return expand("%:t")
	else
		return pathshorten(expand("%:f"))
	endif
endfunction

function! s:AleErrorCount()
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts[0]
endfunction

function! s:AleWarningCount()
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts[1]
endfunction


function! s:CocErrorCount()
	let info = get(b:, 'coc_diagnostic_info', {})
	if empty(info) | return 0 | endif
	return info['error']
endfunction

function! s:CocWarningCount()
	let info = get(b:, 'coc_diagnostic_info', {})
	if empty(info) | return 0 | endif
	return info['warning']
endfunction


function! MinlineLinterErrors()
    if exists('g:loaded_ale')
        return s:AleErrorCount()
    endif
	return s:CocErrorCount()
endfunction

function! MinlineLinterWarnings()
    if exists('g:loaded_ale')
        return s:AleWarningCount()
    endif
	return s:CocWarningCount()
endfunction


function! MinlineStatus()
	let l:statusline = ""
	let l:mode = mode()
	let l:push_right = '%='
	" Setting colors:
	" %*  - Reset
	" %5* - User5

	" Highlight group:
	" %#HighlightGroup#

	" vim mode
	let l:statusline .= MinlineModeColor(l:mode) . ' ' . MinlineModeText(l:mode) . ' ' . s:reset

	" current file
	let l:statusline .=  ' '
	let l:file = MinlineShortFilePath()
	if l:file == ''
		let l:statusline .= s:specialColor . '(new file)' . s:reset
	else
		" linter status (hidden if no errors)
		if MinlineLinterErrors() > 0
			let l:statusline .=  '%#MinlineError#✗' . MinlineLinterErrors() . s:reset
		elseif MinlineLinterWarnings() > 0
			let l:statusline .=  '%#MinlineWarning#▲' . MinlineLinterWarnings() . s:reset
		else
			let l:statusline .= s:specialColor . '✓' . s:reset
		endif

		let l:statusline .= s:separator
		let l:statusline .= '%<' . MinlineShortFilePath() . ' %h%m%r'
	endif

	" move everything after this to right
	let l:statusline .= l:push_right

	let l:statusline .= s:separator . '%2l' . s:specialColor .   ':' . s:reset . '%2v'

	" git branch
	let l:branch = MinlineFugitiveBranch()
	if l:branch != ''
		let l:statusline .= s:separator . l:branch
	endif

	" file type
	if &filetype != ''
		let l:statusline .= s:separator . &filetype
	endif

	" file encoding (hidden if not utf-8)
	if &fileencoding != '' && &fileencoding != 'utf-8'
		let l:statusline .=  s:separator . &fileencoding
	endif

	" file format (hidden if not unix)
	if &fileformat != 'unix'
		let l:statusline .= s:separator . &fileformat
	endif

	let l:statusline .= ' '

	return l:statusline
endfunction

function! s:StatusLine(mode)
	if &buftype == "nofile" || bufname("%") == "[BufExplorer]"
		" Don't set a custom status line for file explorers.
		return
	elseif a:mode == "not-current"
		" Status line for inactive windows.
		setlocal statusline=\ %*%<%{MinlineShortFilePath()}\ %h%m%r
		return
	endif

	" Status line for the active window.
	setlocal statusline=%!MinlineStatus()
endfunction


augroup minlineStatusline
	autocmd!
    autocmd User GitGutter call s:StatusLine("normal")
	autocmd VimEnter,WinEnter,BufWinEnter * call s:StatusLine("normal")
	autocmd WinLeave,FilterWritePost      * call s:StatusLine("not-current")
	" if exists("##CmdlineEnter")
	"     autocmd CmdlineEnter              * call s:StatusLine("command") | redraw
	" endif
augroup END

augroup minlineColors
	autocmd!
	autocmd ColorScheme * call s:ColorScheme()
augroup END
call s:ColorScheme()
