-- Add/change/delete surrounding delimiter pairs with ease. Written with ❤️ in Lua.
return {
  -- https://github.com/kylechui/nvim-surround
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  config = true,
}
