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

## TO-DO
- [x] Port base framework
- [x] Add autocommand support
- [x] Added git message functionality
