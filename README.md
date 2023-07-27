# NO LONGER MAINTAINED
This is plugin is no longer maintained and works well enough for my use case.

Feel free to fork and update as needed.

## nvim-lastplace
A Lua rewrite of vim-lastplace

Heavily inspired by https://github.com/farmergreg/vim-lastplace

## Installation
[packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use 'ethanholz/nvim-lastplace'

```
[paq](https://github.com/savq/paq-nvim)
```lua
paq 'ethanholz/nvim-lastplace'
```

Then add the following to your init.lua:
```lua
require'nvim-lastplace'.setup{}
```
You may set options using the following:
```lua
require'nvim-lastplace'.setup {
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
    lastplace_open_folds = true
}
```

For those of you still using Vimscript to configure your init.vim:
```vim
lua require'nvim-lastplace'.setup{}
```
You can now set options using:
```vim
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
let g:lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
let g:lastplace_open_folds = 1
```
