" A minimal Vim statusline with support for Ale and vim-fugitive
"
" URL:          github.com/mgutz/minline
" License:      MIT (https://opensource.org/licenses/MIT)

if exists("g:loaded_minline")
  finish
endif
let g:loaded_minline = 1

" By default don't display Git branches using the U+E0A0 branch character.
let g:minlineWithGitBranchCharacter = get(g:, "minlineWithGitBranchCharacter", 0)

" By default always use minline colors and ignore any user-defined colors.
let g:minlineHonorUserDefinedColors = get(g:, "minlineHonorUserDefinedColors", 0)

let s:modes = {
  \  "n":      ["%#SpecialKey#", " normal "],
  \  "i":      ["%1*", " insert "],
  \  "R":      ["%4*", " r-mode "],
  \  "v":      ["%3*", " visual "],
  \  "V":      ["%3*", " v-line "],
  \  "\<C-v>": ["%3*", " v-rect "],
  \  "c":      ["%1*", " c-mode "],
  \  "s":      ["%3*", " select "],
  \  "S":      ["%3*", " s-line "],
  \  "\<C-s>": ["%3*", " s-rect "],
  \  "t":      ["%1*", " term "],
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

function! MinlineFugitiveBranch()
    if !exists("g:loaded_fugitive") || !exists("b:git_dir")
        return ""
    endif

    if g:minlineWithGitBranchCharacter
        return "" . fugitive#head()
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

function! MinlineLinterStatus()
  if exists('g:loaded_ale')
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts[0] == 0 ? '' : ' •'.l:counts[0].' '
  endif
  return ''
endfunction

function! MinlineUserColor(num, text)
	return '%' . a:num . '*' . a:text . '%*'
endfunction

function! MinlineStatusLine()
    let l:statusline = ""
    let l:mode = mode()
    let l:reset_color = '%*'
    let l:push_right = '%='

    " Setting colors:
    " %*  - Reset
    " %5* - User5

    " Highlight group:
    " %#HighlightGroup#

    " vim mode
    let l:statusline .= MinlineModeColor(l:mode) . MinlineModeText(l:mode)

    " git branch
    let l:statusline .= '%5* ' . MinlineFugitiveBranch() . ' '

    " current file
    let l:statusline .= '%0* %<' . MinlineShortFilePath() . ' %h%m%r'

    " move everything after this to right
    let l:statusline .= l:push_right

    " linter status (hidden if no errors)
    let l:statusline .= '%#Error#' . MinlineLinterStatus()

    " file type
    let l:statusline .= '%6* ' . &filetype . ' '

    " file encoding (hidden if not utf-8)
    if &fileencoding != 'utf-8'
	let l:statusline .= '%6* ' . &fileencoding . ' '
    endif

    " file format (hidden if not unix)
    if &fileformat != 'unix'
	let l:statusline .= '%6* ' . &fileformat . ' '
    endif

    " 4 digits for row, 3 digits for col, fixed width so ':' does not move
    let l:statusline .= '%5*%4l:%-3v'

    return l:statusline
endfunction

function! s:StatusLine(mode)
    if &buftype == "nofile" || bufname("%") == "[BufExplorer]"
        " Don't set a custom status line for file explorers.
        return
    elseif a:mode == "not-current"
        " Status line for inactive windows.
        setlocal statusline=\ %*%<%{MinlineShortFilePath()}\ %h%m%r
        "setlocal statusline+=%*%=%-14.(%l,%c%V%)[%L]\ %P
        return
    endif

    " Status line for the active window.
    setlocal statusline=%!MinlineStatusLine()
endfunction

function! s:UserColors()
    if g:minlineHonorUserDefinedColors
        return
    endif

    exec "highlight User1 ctermbg=4   guibg=" . s:blue    . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User2 ctermbg=251 guibg=" . s:white   . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User3 ctermbg=13  guibg=" . s:purple  . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User4 ctermbg=9   guibg=" . s:crimson . " ctermfg=234 guifg=" . s:grey234
    exec "highlight User5 ctermbg=236 guibg=" . s:grey236 . " ctermfg=10  guifg=" . s:emerald . " gui=none"
    exec "highlight User6 ctermbg=236 guibg=" . s:grey236 . " ctermfg=251 guifg=" . s:white   . " gui=none"
    exec "highlight User7 ctermbg=236 guibg=" . s:grey236 . " ctermfg=4   guifg=" . s:blue    . " gui=none"
    exec "highlight User8 ctermbg=236 guibg=" . s:grey236 . " ctermfg=9   guifg=" . s:crimson . " gui=none"
endfunction

augroup minlineStatusline
    autocmd!
    autocmd VimEnter,SourcePre            * call s:UserColors()
    autocmd VimEnter,WinEnter,BufWinEnter * call s:StatusLine("normal")
    autocmd WinLeave,FilterWritePost      * call s:StatusLine("not-current")
    " if exists("##CmdlineEnter")
    "     autocmd CmdlineEnter              * call s:StatusLine("command") | redraw
    " endif
augroup END
