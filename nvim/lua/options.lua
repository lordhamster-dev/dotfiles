vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.encoding = "UTF-8"
vim.opt.fileencoding = "utf-8"
vim.opt.scrolloff = 8 -- jk移动时光标上下方保留8行
vim.opt.mousemoveevent = true
vim.opt.list = true
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- For fold
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.fillchars = { fold = " " } -- 用空格替代点
vim.opt.foldexpr = "v:lua.require('util.foldmethod').foldexpr()"
vim.wo.foldtext = "v:lua.require('util.foldmethod').markdown_foldtext()"

vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.wrap = false -- disable line wrapping
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.termguicolors = true
vim.opt.background = "dark" -- colorschemes that can be light or dark will be made dark
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom
vim.opt.iskeyword:append("-") -- consider string-string as whole word
vim.opt.winbar = "%=%t"
vim.opt.winborder = "rounded"
vim.opt.conceallevel = 1

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end,
})

-- Disable line numbers in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Auto save
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
-- 	pattern = { "*" },
-- 	command = "silent! wall",
-- 	nested = true,
-- })
