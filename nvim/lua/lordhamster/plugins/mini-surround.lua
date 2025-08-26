-- Neovim Lua plugin with fast and feature-rich surround actions. Part of 'mini.nvim' library.
return {
  -- https://github.com/echasnovski/mini.surround
  "echasnovski/mini.surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*",
  config = true,
}
