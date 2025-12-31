-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false
vim.g.snacks_animate = false
vim.opt.relativenumber = false
vim.opt.spelllang = { "en", "tr" }
vim.opt.colorcolumn = "100"
vim.opt.cursorline = false

-- set active indention color to something not very distractive
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#494d64" })
