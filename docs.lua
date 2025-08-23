---@meta

---@class zoxide
---@field setupOpts zoxide.setupOpts
---@field z fun(opts: { [1]: string, list: boolean?}|string)?
---@field setup fun(setupOpts: zoxide.setupOpts)|nil

---@class zoxide.setupOpts
---@field lsd zoxide.setupOpts.lsd?
---@field tree zoxide.setupOpts.tree?
---@field treeCommands string[][]?
---@field treeCommand string[]?

---@alias lsdChoice "always"|"auto"|"never"|nil
---@class zoxide.setupOpts.lsd
---@field color lsdChoice
---@field icon lsdChoice
---@field iconTheme "fancy"|"unicode"|nil
---@field depth integer?

---@class zoxide.setupOpts.tree
---@field depth integer?
---@field ignorePattern string?
