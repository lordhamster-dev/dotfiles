-- Bootstrap lazy.nvim
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  { import = "lordhamster.plugins" },
  { import = "lordhamster.plugins.lsp" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = true,
  },
})

require("lordhamster.util.sql_query").setup({
  default_db = "questdb",
  questdb = {
    host = os.getenv("QUESTDB_HOST") or "localhost",
    port = os.getenv("QUESTDB_PORT") and tonumber(os.getenv("QUESTDB_PORT")) or 9000,
    username = os.getenv("QUESTDB_USER") or "admin",
    password = os.getenv("QUESTDB_PASS") or "quest",
  },
  postgresql = {
    host = "localhost",
    port = 5432,
    database = "",
    username = "",
    password = "",
  },
  result_window = {
    height = 30,
  },
})
