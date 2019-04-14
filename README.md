# minline

_minline_ is a simple status line for Vim

It's meant to be forked. Got tired of issues with using statusline plugins
and conflicts with other plugins.

Supports these plugins

- [ale](https://github.com/w0rd/ale) linter
- [fugitive](https://github.com/tpope/vim-fugitive) git utilities

## Options

### g:minlineWithGitBranchCharacter

_minline statusline_ supports Tim Pope's
[fugitive](https://github.com/tpope/vim-fugitive) plugin.

The `g:minlineWithGitBranchCharacter` option specifies whether to display Git
branch details using the Unicode Git branch character `U+E0A0`. By default Git
branches displayed in the `statusline` will not use that character since many
monospace fonts will not contain it. However, some modern fonts, such as [Fira
Code](https://github.com/tonsky/FiraCode) and
[Iosevka](https://github.com/be5invis/Iosevka), do contain the Git branch
character.

If `g:minlineWithGitBranchCharacter` is unset the default value from
the fugitive plugin will be used.

To display the Unicode Git branch character please add the following to your
_vimrc_:

```viml
let g:minlineWithGitBranchCharacter = 1
```

### g:minlineHonorUserDefinedColors

The `g:minlineHonorUserDefinedColors` option specifies whether user-defined
colors should be used instead of the default colors from the minline color
scheme.

```viml
let g:minlineHonorUserDefinedColors = 1
```

For example, these user-defined colors mimic Vim's default statusline colors:

```viml
highlight! link User1 StatusLine
highlight! link User2 DiffAdd
highlight! link User3 DiffChange
highlight! link User4 DiffDelete
highlight! link User5 StatusLine
highlight! link User6 StatusLine
highlight! link User7 StatusLine
```

## License

Mdified from [moonfly](https://github.com/bluz71/vim-moonfly-statusline)

[MIT](https://opensource.org/licenses/MIT)
