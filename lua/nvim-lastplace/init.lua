local fn = vim.fn
local lastplace = {}

local function split_on_comma(str)
	local ret_tab = {}
	if str == nil then
		return nil
	end
	for word in string.gmatch(str, "([^,]+)") do
		table.insert(ret_tab, word)
	end
	return ret_tab
end

local function set_option(option, default)
	-- Coalesce boolean options to integer 0 or 1
	if type(lastplace.options[option]) == "boolean" then
		lastplace.options[option] = lastplace.options[option] and 1 or 0
	end

	-- Set option to either the option value or the default
	lastplace.options[option] = lastplace.options[option] or split_on_comma(vim.g[option]) or default
end

local function check_version(major, minor, patch)
	local version = vim.version()
	return version.major >= major and version.minor >= minor and patch >= version.patch
end

function lastplace.setup(options)
	options = options or {}
	lastplace.options = options
	set_option("lastplace_ignore_buftype", { "quickfix", "nofile", "help" })
	set_option("lastplace_ignore_filetype", { "gitcommit", "gitrebase", "svn", "hgcommit" })
	set_option("lastplace_open_folds", 1)
	if check_version(0, 7, 0) then
		local group_name = "NvimLastplace"
		vim.api.nvim_create_augroup(group_name, { clear = true })
		vim.api.nvim_create_autocmd("BufWinEnter", { callback = lastplace.lastplace_buf, group = group_name })
		vim.api.nvim_create_autocmd("FileType", { callback = lastplace.lastplace_buf, group = group_name })
	else
		vim.cmd([[augroup NvimLastplace]])
		vim.cmd([[  autocmd!]])
		vim.cmd([[  autocmd BufWinEnter * lua require('nvim-lastplace').lastplace_buf()]])
		if not check_version(0, 5, 1) then
			-- if fn.has("nvim-0.5.1") == 0 then
			vim.cmd([[  autocmd FileType * lua require('nvim-lastplace').lastplace_ft()]])
		end
		vim.cmd([[augroup end]])
	end
end

local set_cursor_position = function()
	local last_line = fn.line([['"]])
	local buff_last_line = fn.line("$")
	local window_last_line = fn.line("w$")
	local window_first_line = fn.line("w0")
	-- If the last line is set and the less than the last line in the buffer
	if last_line > 0 and last_line <= buff_last_line then
		-- Check if the last line of the buffer is the same as the window
		if window_last_line == buff_last_line then
			-- Set line to last line edited
			vim.api.nvim_command([[normal! g`"]])
			-- Try to center
		elseif buff_last_line - last_line > ((window_last_line - window_first_line) / 2) - 1 then
			vim.api.nvim_command([[normal! g`"zz]])
		else
			vim.api.nvim_command([[normal! G'"<c-e>]])
		end
	end
	if fn.foldclosed(".") ~= -1 and lastplace.options.lastplace_open_folds == 1 then
		vim.api.nvim_command([[normal! zvzz]])
	end
end

function lastplace.lastplace_buf()
	-- Check if the buffer should be ignored
	if vim.tbl_contains(lastplace.options.lastplace_ignore_buftype, vim.api.nvim_buf_get_option(0, "buftype")) then
		return
	end

	if check_version(0, 5, 1) then
		-- if fn.has("nvim-0.5.1") == 1 then
		-- Check if the filetype should be ignored
		if
			vim.tbl_contains(lastplace.options.lastplace_ignore_filetype, vim.api.nvim_buf_get_option(0, "filetype"))
		then
			-- reset cursor to first line
			vim.api.nvim_command([[normal! gg]])
			return
		end
	end

	-- If a line has already been specified on the command line, we are done
	--   nvim file +num
	if fn.line(".") > 1 then
		return
	end

	set_cursor_position()
end

function lastplace.lastplace_ft()
	-- Check if the buffer should be ignored
	if vim.tbl_contains(lastplace.options.lastplace_ignore_buftype, vim.api.nvim_buf_get_option(0, "buftype")) then
		return
	end

	-- Check if the filetype should be ignored
	if vim.tbl_contains(lastplace.options.lastplace_ignore_filetype, vim.api.nvim_buf_get_option(0, "filetype")) then
		-- reset cursor to first line
		vim.api.nvim_command([[normal! gg]])
		return
	end

	-- If a line has already been set by the BufReadPost event or on the command
	-- line, we are done.
	if fn.line(".") > 1 then
		return
	end

	-- This shouldn't be reached but, better have it ;-)
	set_cursor_position()
end

return lastplace
