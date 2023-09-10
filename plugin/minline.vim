" A minimal Vim statusline with support for Ale and vim-fugitive
"
" URL:          github.com/mgutz/minline
" License:      MIT (https://opensource.org/licenses/MIT)

" Options:
"   - minlineWithGitBranchCharacter : git glyph
"   - minlineHonorUserDefinedColors : activate user defined colors
"   - minlineGitFieldStyle          : graphic style of the git status field
"                                     can be: airline (default), colorblock, arrow, bar
"   - minlineGitFieldBg             : git field bg color

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
" Change here the text rendered in the 'mode' field of the bar
" The %num* are the user's numbers (User1, User2, etc.)
" For each user a color is set (see below "highlight User...")
" Their are used if minlineHonorUserDefinedColors is set
let s:modes = {
			\  "n":      ["%#MinlineNormalMode#", "normal" ],
			\  "i":      ["%1*", "insert"],
			\  "R":      ["%4*", "R"],
			\  "v":      ["%2*", "visual"],
			\  "V":      ["%3*", "VISUAL"],
			\  "\<C-v>": ["%3*", "^v"],
			\  "c":      ["%1*", "c"],
			\  "s":      ["%3*", "s"],
			\  "S":      ["%3*", "S"],
			\  "\<C-s>": ["%3*", "^s"],
			\  "t":      ["%1*", "t"],
			\}


" The minline colors (https://github.com/bluz71/vim-minline-colors)
let s:white   = "#c6c6c6" " white   = 251
let s:yellow  = "#ffd700"
let s:grey236 = "#ffffff" " grey236 = 236
let s:grey234 = "#ffffff" " grey234 = 234
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
let s:separatorColor  = '%#MinlineSeparator#'
let s:glyphColor      = '%#MinlineGlyph#'
let s:gitFieldColor   = '%#MinlineGitField#'
let s:gitAirline      = '%#MinlineAirline#'
let s:vbar   = '│'
let s:rsep   = ''
let s:middot = '·'
let g:bar  = get(g:, "minlineBarSeparator", 0)          " for right separators only

if g:bar
    let s:rsep = s:vbar
endif

let s:rseparator = s:separatorColor . ' ' . s:rsep . ' ' . s:reset

if g:minlineWithGitBranchCharacter
    let s:gitGlyph = s:glyphColor . ' ' . ''
else
    let s:gitGlyph = s:glyphFieldColor . ' ' . '~'
endif

let g:minlineGitFieldStyle = get(g:, "minlineGitFieldStyle", "bar") " style of git status field

if g:minlineGitFieldStyle == "airline"
    let s:gitEnd = s:gitAirline . '' . s:reset
elseif g:minlineGitFieldStyle == "colorblock"
    let s:gitEnd = ' ' . s:reset
elseif g:minlineGitFieldStyle == "arrow"
    let s:gitEnd = s:separatorColor . '' . s:reset
else
    let s:gitEnd = s:separatorColor . s:vbar . s:reset
endif

function! s:ColorScheme()
	if g:minlineHonorUserDefinedColors
		return
	endif

    " For the bar, use the colorscheme colors
	let l:ctermbg = s:getHighlightTerm('StatusLine', 'ctermbg')
	let l:ctermfg = s:getHighlightTerm('StatusLine', 'ctermfg')
    let l:gitbg   = get(g:, "minlineGitFieldBg", l:ctermbg)


	" Set FG only and use existing StatusLine BG
	call s:ExecHighlightGroup('MinlineError', '1', l:ctermbg)
	call s:ExecHighlightGroup('MinlineWarning', '3', l:ctermbg)
	call s:ExecHighlightGroup('MinlineSeparator','240', l:ctermbg)
	call s:ExecHighlightGroup('MinlineGlyph', '53', l:gitbg)
	call s:ExecHighlightGroup('MinlineGitField', l:ctermfg, l:gitbg)
	call s:ExecHighlightGroup('MinlineAirline', l:gitbg, l:ctermbg)
	call s:ExecHighlightGroup('MinlineReverse', l:ctermbg, l:ctermfg)

    " To use reverted Statusline bg/fg colors in normal mode:
	" call s:ExecHighlightGroup('MinlineNormalMode', l:ctermbg, l:ctermfg)
    call s:ExecHighlightGroup('MinlineNormalMode', '17', '2')

	exec "highlight User1 ctermbg=4   guibg=" . s:blue    . " ctermfg=17 guifg=" . s:grey234
	exec "highlight User2 ctermbg=2   guibg=" . s:yellow  . " ctermfg=17 guifg=" . s:grey234
	exec "highlight User3 ctermbg=6   guibg=" . s:purple  . " ctermfg=17 guifg=" . s:grey234
	exec "highlight User4 ctermbg=9   guibg=" . s:crimson . " ctermfg=17 guifg=" . s:grey234
	exec "highlight User5 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10  guifg=" . s:emerald . " gui=none"
	exec "highlight User6 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
	exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
	exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=9   guifg=" . s:crimson . " gui=none"
endfunction


" Get the file path
function! MinlineFilePath()
	if &buftype == "terminal"
		return expand("%:t")
	else
		return expand("%:f")
	endif
endfunction


" Return the git branch name get by GetGitBranch
" GetGitBranch is called with an autocommand see below at the end of the script
function! ShowGitBranch() abort
  return get(g:, 'git_branch', '')
endfunction

function! GetGitBranch() abort
  let g:git_branch = system('git symbolic-ref --short HEAD 2>/dev/null || echo -n "x"')[:-2]

  if g:git_branch == ''
    return
  else
    let g:git_branch = g:git_branch[:13]
  endif
endfunction


" Main function building the status line
function! MinlineStatus()
	let l:statusline = ""
	let l:mode = mode()
	let l:push_right = '%='
	" Setting colors:
	" %*  - Reset
	" %5* - User5

	" Highlight group:
	" %#HighlightGroup#

	" vim mode (left square with n/i/V letters...)
	let l:statusline .= MinlineModeColor(l:mode) . ' ' . MinlineModeText(l:mode) . ' ' . s:reset

    " Git status field
    let l:statusline .= s:gitGlyph . s:gitFieldColor . '  ' . ShowGitBranch() . '  ' . s:gitEnd

	" current file
	let l:file = MinlineFilePath()
	if l:file != ''
		let l:statusline .= ' ' . '%<' . MinlineFilePath() . ' %h%m%r'
	endif

	" move everything after this to right
	let l:statusline .= l:push_right

	let l:statusline .= s:rseparator . '%2l' . s:separatorColor .   ':' . s:reset . '%2v'

	" git branch
"	let l:branch = MinlineFugitiveBranch()
"	if l:branch != ''
"		let l:statusline .= s:lseparator . l:branch
"	endif

	" file type
	if &filetype != ''
		let l:statusline .= s:rseparator  . &filetype
	endif

	" file encoding (show only if not utf-8)
	if &fileencoding != '' && &fileencoding != 'utf-8'
		let l:statusline .=  s:rseparator . &fileencoding
	endif

	" file format (show only if not unix)
	if &fileformat != 'unix'
		let l:statusline .= s:rseparator . &fileformat
	endif

	let l:statusline .= ' '

	return l:statusline
endfunction


" Run the status line
function! s:StatusLine(mode)
	if &buftype == "nofile" || bufname("%") == "[BufExplorer]"
		" Don't set a custom status line for file explorers.
		return
	elseif a:mode == "not-current"
		" Status line for inactive windows.
		setlocal statusline=\ %*%<%{MinlineFilePath()}\ %h%m%r
		return
	endif

	" Status line for the active window.
	setlocal statusline=%!MinlineStatus()
endfunction

augroup StatusLine
  au!
  autocmd BufEnter * call GetGitBranch()
augroup end

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
