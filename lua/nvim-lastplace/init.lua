local fn = vim.fn
local lastplace = {}

function lastplace:setup(options)
	options = options or {}
	lastplace.options = options	
	lastplace:set_option("lastplace_ignore_buftype",{'quickfix','nofile','help'})
	lastplace:set_option("lastplace_ignore_filetype",{'gitcommit','gitrebase','svn','hgcommit'})
	lastplace:set_option("lastplace_open_folds", 1)
	vim.cmd[[autocmd BufWinEnter * lua require'nvim-lastplace'.lastplace_func()]]
end

function lastplace:set_option(option,default)
	-- Coalesce boolean options to integer 0 or 1
    	if type(lastplace.options[option]) == "boolean" then
        	lastplace.options[option] = lastplace.options[option] and 1 or 0
    	end
	-- Set option to either the option value or the default
	lastplace.options[option] = lastplace.options[option] or default
end

function lastplace:lastplace_func()
	-- Get buffer and filetype
	local buf = vim.bo.buftype
	local ft = vim.bo.filetype
	for i,v in ipairs(lastplace.options.lastplace_ignore_buftype) do
		if v == buf then return end
	end
	for i,v in ipairs(lastplace.options.lastplace_ignore_filetype) do
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
				vim.api.nvim_command([[normal! g`"]])
			-- Try to center
			elseif fn.line("$") - fn.line([['"]]) > ((fn.line("w$") - fn.line("w0")) / 2) - 1 then
				vim.api.nvim_command([[normal! g`"zz]])
			else
				vim.api.nvim_command([[normal! G'"<c-e>]])
			end
		end
		if fn.foldclosed(".") ~= -1 and lastplace.options.lastplace_open_folds == 1 then
			vim.api.nvim_command([[normal! zvzz]])
		end
	end
end

return lastplace
