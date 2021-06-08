# nvim-lastplace
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

## TO-DO
- [x] Port base framework
- [x] Add autocommand support
- [x] Added git message functionality
- [x] Fold support
- [x] Extensible option support
