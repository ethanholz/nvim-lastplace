local fn = vim.fn

vim.fn = vim.fn or setmetatable({}, {
  __index = function(t, key)
    local function _fn(...)
      return vim.api.nvim_call_function(key, { ... })
    end
    t[key] = _fn
    return _fn
  end,
})

local function setup()
	vim.cmd[[autocmd BufWinEnter * lua require'nvim-lastplace'.lastplace_func()]]
end
local lastplace_ignore_buftype={'quickfix','nofile','help'}
local lastplace_ignore_filetype={'gitcommit','gitrebase','svn','hgcommit'}
local function lastplace_func()
	-- Get buffer and filetype
	local buf = vim.bo.buftype
	local ft = vim.bo.filetype
	for i,v in ipairs(lastplace_ignore_buftype) do
		if v == buf then return end
	end
	for i,v in ipairs(lastplace_ignore_filetype) do
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
	end
end

return {
	setup = setup,
	lastplace_func = lastplace_func
}
