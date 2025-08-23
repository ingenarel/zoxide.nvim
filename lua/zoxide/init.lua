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
    if not opts.list and (type(opts[1]) ~= "string" or opts[1] == "") then
        error("opts[1] isn't a non empty string")
    end

    local zoxideCommand = { "zoxide", "query" }
    if opts.list then
        table.insert(zoxideCommand, "-l")
        table.insert(zoxideCommand, "-s")
    end
    table.insert(zoxideCommand, opts[1])
    local lastZoxideExecData = {}
    lastZoxideExecData = vim.system(zoxideCommand, {}, function()
        vim.schedule(function()
            if opts.list then
                --TODO: make this a telescope module later
                if vim.fn.exists("g:loaded_telescope") == 1 then
                    local actions = require("telescope.actions")
                    local dirData = {}
                    for _, value in ipairs(lastZoxideExecData) do
                        for line in vim.gsplit(value, "\n", { trimempty = true }) do
                            table.insert(dirData, strip(line))
                        end
                    end
                    require("telescope.pickers")
                        .new({}, {
                            prompt_title = "zoxide",
                            sorter = require("telescope.config").values.generic_sorter(nil),
                            finder = require("telescope.finders").new_table { results = dirData },
                            attach_mappings = function(prompt_bufnr, map)
                                actions.select_default:replace(function()
                                    actions.close(prompt_bufnr)
                                    --TODO: figure out if there is a way to influence the score instead of printing out the
                                    --score and then doing string manupulation like this
                                    local dir = string.gsub(
                                        require("telescope.actions.state").get_selected_entry()[1],
                                        "^[%d.]+%s+",
                                        ""
                                    )
                                    vim.cmd.cd(dir)
                                    vim.cmd.pwd()
                                end)

                                return true
                            end,
                            previewer = require("telescope.previewers").new_termopen_previewer {
                                get_command = function(entry)
                                    local dir = string.gsub(entry[1], "^[%d.]+%s+", "")
                                    local tmpCommand = {}
                                    for _, command in ipairs(m.treeCommand) do
                                        table.insert(tmpCommand, command)
                                    end
                                    table.insert(tmpCommand, dir)
                                    return tmpCommand
                                end,
                            },
                        })
                        :find()
                end
            else
                vim.cmd.cd(strip(lastZoxideExecData[1]))
            end
        end)
    end)._state.stdout_data
end

function m.setup(setupOpts)
    vim.api.nvim_create_user_command("Z", function(opts)
        m.z { opts.args }
    end, { nargs = "?" })
    vim.api.nvim_create_user_command("Zf", function(opts)
        m.z { opts.args, list = true }
    end, { nargs = "?" })

    setupOpts.lsd = {}
    ---@alias lsdChoice "always"|"auto"|"never"|nil
    ---@type lsdChoice
    setupOpts.lsd.color = setupOpts.lsd.color
    ---@type lsdChoice
    setupOpts.lsd.icon = setupOpts.lsd.icon
    ---@type "fancy"|"unicode"|nil
    setupOpts.lsd.iconTheme = setupOpts.lsd.iconTheme or "fancy"
    ---@type integer
    setupOpts.lsd.depth = setupOpts.lsd.depth or 4
    for _, value in ipairs { "color", "icon" } do
        if not setupOpts.lsd[value] then
            local term = string.format("%s", os.getenv("TERM"))
            if os.getenv("WAYLAND_DISPLAY") or string.find(term, "256") or string.find(term, "xterm") then
                setupOpts.lsd[value] = "always"
            else
                setupOpts.lsd[value] = "auto"
            end
        end
    end
    setupOpts.treeCommands = setupOpts.treeCommands
        or {
            {
                "lsd",
                "--tree",
                "--color=" .. setupOpts.lsd.color,
                "--icon=" .. setupOpts.lsd.icon,
                "--icon-theme=" .. setupOpts.lsd.iconTheme,
                "--depth=" .. string.format("%d", setupOpts.lsd.depth),
            },
            { "tree" },
            { "fd", "." },
        }
    for _, command in pairs(setupOpts.treeCommands) do
        if vim.fn.executable(command[1]) == 1 then
            m.treeCommand = command
            break
        end
    end
end

return m
