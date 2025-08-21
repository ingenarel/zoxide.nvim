local m = {}

function m.z(opts)
	opts = opts or {}
	local lastZoxideExecData = {}
	lastZoxideExecData = vim.system({ "zoxide", "query", opts[1] }, {}, function()
		vim.schedule(function()
			m.changeDir(lastZoxideExecData[1])
		end)
	end)._state.stdout_data
end

function m.changeDir(query)
	if query then
		vim.cmd.cd(string.sub(query, 1, -2))
	end
end

function m.setup()
	vim.api.nvim_create_user_command("Z", function(opts)
		m.z({ opts.args })
	end, { nargs = "?" })
end

return m
