local U = require('nvim-lastplace.config')
local fn = vim.fn
local cmd = vim.api.nvim_command

local utils = {}

function utils:new()
	config = {}
	self.__index = self
    	return setmetatable(config, self)
end

function utils:setup(opts)
	self.config = U.create_config(opts)
	cmd[[autocmd BufWinEnter * lua require'nvim-lastplace.utils'.lastplace_func()]]
	return self

end

function utils:lastplace_func()
	-- Get buffer and filetype
	local buf = vim.bo.buftype
	local ft = vim.bo.filetype
	local buftypes = self.config.lastplace_ignore_buftype
	for i,v in ipairs(buftypes) do
		if v == buf then return end
	end
	for i,v in ipairs(self.lastplace_ignore_filetype) do
		if v == ft then return end
	end
	-- Check if file exists, if so load
	local file = fn.empty(fn.glob(fn.expand('%@')))
	if file then
		-- If the last line is set and the less than the last line in the buffer
		if fn.line([['"]]) > 0 and fn.line([['"]]) <= fn.line("$") then
			--Check if the last line of the buffer is the same as the window 
			if fn.line("w$") == fn.line("$") then
				--Set line to last line edited
				cmd([[normal! g`"]])
			-- Try to center
			elseif fn.line("$") - fn.line([['"]]) > ((fn.line("w$") - fn.line("w0")) / 2) - 1 then
				cmd([[normal! g`"zz]])
			else
				cmd([[normal! G'"<c-e>]])
			end
		end
	end
end

return utils
