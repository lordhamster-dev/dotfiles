-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- Use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- Without copying into register
keymap.set("n", "x", '"_x')
keymap.set("n", "c", '"_c')

-- Window
keymap.set("n", "<C-w>\\", ":vsp<CR>")
keymap.set("n", "<C-w>-", ":sp<CR>")
-- keymap.set("n", "<C-k>", "<C-w>k")
-- keymap.set("n", "<C-j>", "<C-w>j")
-- keymap.set("n", "<C-h>", "<C-w>h")
-- keymap.set("n", "<C-l>", "<C-w>l")

-- Search UP for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
vim.keymap.set("n", "gk", function()
  -- `?` - Start a search backwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd("silent! ?^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "Go to previous markdown header" })

-- Search DOWN for a markdown header
-- Make sure to follow proper markdown convention, and you have a single H1
-- heading at the very top of the file
-- This will only search for H2 headings and above
vim.keymap.set("n", "gj", function()
  -- `/` - Start a search forwards from the current cursor position.
  -- `^` - Match the beginning of a line.
  -- `##` - Match 2 ## symbols
  -- `\\+` - Match one or more occurrences of prev element (#)
  -- `\\s` - Match exactly one whitespace character following the hashes
  -- `.*` - Match any characters (except newline) following the space
  -- `$` - Match extends to end of line
  vim.cmd("silent! /^##\\+\\s.*$")
  -- Clear the search highlight
  vim.cmd("nohlsearch")
end, { desc = "Go to next markdown header" })

----------------------
-- Plugin Keybinds
----------------------

-- Buffer Switch
keymap.set("n", "H", "<cmd>BufferLineCyclePrev<CR>")
keymap.set("n", "L", "<cmd>BufferLineCycleNext<CR>")
