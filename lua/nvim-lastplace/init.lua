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

local function lastplace_func()
	-- Check if file exists, if so load
	local file = fn.empty(fn.glob(fn.expand('%@')))
	if file then
		if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
			if fn.line("w$") == fn.line("$") then
				vim.api.nvim_command('normal! g`\"')
			elseif fn.line("$") - fn.line("'\"") > ((fn.line("w$") - fn.line("w0")) / 2) - 1 then
				vim.api.nvim_command('normal! g`\"zz')
			else
				vim.api.nvim_command([[normal! \G'\"\<c-e>]])
			end
		end
	end
end

return {
	setup = setup,
	lastplace_func = lastplace_func
}
