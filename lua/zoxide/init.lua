local m = { lastZoxideExecData = {} }

function m.z(query)
	m.lastZoxideExecData = vim.system({ "zoxide", "query", query }, {}, function()
		vim.schedule(function()
			m.changeDir()
		end)
	end)
end

function m.changeDir(query)
	vim.cmd.cd(string.sub(m.lastZoxideExecData._state.stdout_data[1], 1, -2))
end

function m.setup()
	vim.api.nvim_create_user_command("Z", function(opts)
		m.z(opts.args)
	end, { nargs = "?" })
end

return m
