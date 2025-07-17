local opt = vim.opt -- for conciseness

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- utf8
opt.encoding = "UTF-8"
opt.fileencoding = "utf-8"

-- jk移动时光标下上方保留8行
-- opt.scrolloff = 8
-- opt.sidescrolloff = 8

-- Mouse stuf
opt.mousemoveevent = true

opt.list = true
-- opt.listchars:append("space:⋅")
-- opt.listchars:append("eol:↴")

-- Save undo history
opt.undofile = true

-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- For fold
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.require'lordhamster.util.foldmethod'.foldexpr()"

-- 补全增强
-- vim.o.wildmenu = true

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

-- status line
opt.winbar = "%=%t"

opt.conceallevel = 1

-- Auto save
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
-- 	pattern = { "*" },
-- 	command = "silent! wall",
-- 	nested = true,
-- })

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end,
})

local function get_os()
  local uname = vim.loop.os_uname()
  local sysname = uname.sysname

  if sysname == "Darwin" then
    return "mac"
  elseif sysname == "Linux" then
    return "linux"
  else
    return "unknown"
  end
end

local os = get_os()

-- 进入 normal 模式时切换为英文输入法
if os == "mac" then
  vim.cmd([[
    augroup input_method
      autocmd!
      autocmd InsertLeave * :lua vim.fn.system("im-select com.apple.keylayout.ABC")
    augroup END
  ]])
elseif os == "linux" then
  vim.cmd([[
    augroup input_method
      autocmd!
      autocmd InsertLeave * :lua vim.fn.system("fcitx5-remote -c")
    augroup END
  ]])
else
  print("Unknown operating system")
end

-- 禁用终端行号
vim.cmd([[
  augroup NoLineNumbersInTerminal
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END
]])

-- vim.api.nvim_create_user_command("Rfinder", function()
--   local path = vim.api.nvim_buf_get_name(0)
--   os.execute("open -R " .. path)
-- end, {})

-- Basic autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

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
