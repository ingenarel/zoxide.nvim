---@meta

---@class zoxide
---@field setupOpts zoxide.setupOpts
---@field treeCommands string[][]?
---@field z fun(opts: { [1]: string, list: boolean?}|string)?
---@field setup fun(setupOpts: zoxide.setupOpts)|nil
---@field treeCommand string[]?

---@class zoxide.setupOpts
---@field lsd zoxide.setupOpts.lsd?

---@alias lsdChoice "always"|"auto"|"never"|nil
---@class zoxide.setupOpts.lsd
---@field color lsdChoice
---@field icon lsdChoice
---@field iconTheme "fancy"|"unicode"|nil
---@field depth integer?
