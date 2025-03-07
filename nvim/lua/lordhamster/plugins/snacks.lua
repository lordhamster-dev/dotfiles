return {
  -- https://github.com/folke/snacks.nvim
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    animate = {},
    bigfile = { enabled = true },
    lazygit = {},
    image = {},
    zen = {
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
      show = {
        statusline = false, -- can only be shown when using the global statusline
        tabline = false,
      },
      win = { style = "zen" },
      zoom = {
        toggles = {},
        show = { statusline = true, tabline = true },
        win = {
          backdrop = false,
          width = 0, -- full width
        },
      },
    },
  },
}
