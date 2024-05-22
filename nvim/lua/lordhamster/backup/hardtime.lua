-- A Neovim plugin helping you establish good command workflow and quit bad habit
return {
  -- https://github.com/m4xshen/hardtime.nvim
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  opts = {},
}
