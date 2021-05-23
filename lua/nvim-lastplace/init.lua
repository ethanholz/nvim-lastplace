local fn = vim.fn
local lastplace = {}

local function set_option(option,default)
	-- Coalesce boolean options to integer 0 or 1
    	if type(lastplace.options[option]) == "boolean" then
        	lastplace.options[option] = lastplace.options[option] and 1 or 0
    	end
	-- Set option to either the option value or the default
	lastplace.options[option] = lastplace.options[option] or default
end

function lastplace:setup(options)
	options = options or {}
	lastplace.options = options
	set_option("lastplace_ignore_buftype",{'quickfix','nofile','help'})
	set_option("lastplace_ignore_filetype",{'gitcommit','gitrebase','svn','hgcommit'})
	set_option("lastplace_open_folds", 1)
	vim.cmd[[augroup NvimLastplace]]
	vim.cmd[[  autocmd!]]
	vim.cmd[[  autocmd BufReadPost * lua require'nvim-lastplace'.lastplace_func()]]
	vim.cmd[[augroup end]]
end

function lastplace:lastplace_func()
	-- Check if buffer should be ignored
	if vim.tbl_contains(lastplace.options.lastplace_ignore_buftype,
			vim.api.nvim_buf_get_option(0, 'buftype')) or
		vim.tbl_contains(lastplace.options.lastplace_ignore_filetype,
			vim.api.nvim_buf_get_option(0, 'filetype')) then
		return
	end

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

return lastplace
