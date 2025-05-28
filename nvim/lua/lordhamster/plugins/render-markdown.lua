-- Plugin to improve viewing Markdown files in Neovim
return {
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    sign = { enabled = false },
    file_types = { "markdown", "codecompanion" },
    checkbox = { checked = { icon = "󰸞 " } },
  },
  ft = { "markdown", "codecompanion" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
}
