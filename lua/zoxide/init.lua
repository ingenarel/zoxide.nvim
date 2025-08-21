local m = {}

local function strip(str)
	str = string.gsub(str, "^%s+", "")
	str = string.gsub(str, "%s+$", "")
	return str
end

---@param opts table|string
function m.z(opts)
	if type(opts) == "string" then
		local tmp = opts
		opts = {}
		opts[1] = tmp
	elseif type(opts) ~= "table" then
		error("opts is neither a table nor a string")
	end
	if type(opts[1]) ~= "string" or opts[1] == "" then
		error("opts[1] isn't a non empty string")
	end
	local lastZoxideExecData = {}
	lastZoxideExecData = vim.system({ "zoxide", "query", opts[1] }, {}, function()
		vim.schedule(function()
			vim.cmd.cd(strip(lastZoxideExecData[1]))
		end)
	end)._state.stdout_data
end

function m.setup()
	vim.api.nvim_create_user_command("Z", function(opts)
		m.z({ opts.args })
	end, { nargs = "?" })
end

return m
