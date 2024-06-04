-- Git integration for buffers
return {
  -- https://github.com/lewis6991/gitsigns.nvim
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "tpope/vim-fugitive",
  },
  config = function()
    -- https://github.com/lewis6991/gitsigns.nvim
    require("gitsigns").setup({
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    })
  end,
}
