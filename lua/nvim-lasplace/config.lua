local U = {}

local O = {
	lastplace_ignore_filetype={'gitcommit','gitrebase','svn','hgcommit'},
	lastplace_ignore_buftype={'quickfix','nofile','help'}
}

function U.create_config(opts)
	if not opts then
		return O
	end

	return {
		lastplace_ignore_filetype = opts.lastplace_ignore_filetype or cmd.lastplace_ignore_filetype,
		lastplace_ignore_buftype = opts.lastplace_ignore_buftype or cmd.lastplace_ignore_buftype
	}
end

return U
