-- Plugin to improve viewing Markdown files in Neovim
return {
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    sign = { enabled = false },
    file_types = { "markdown", "codecompanion" },
    checkbox = { checked = { icon = "󰸞 " } },
    heading = {
      icons = { " 󰼏 ", " 󰎨 ", " 󰼑 ", " 󰎲 ", " 󰼓 ", " 󰎴 " },
      border = true,
      render_modes = true, -- keep rendering while inserting
    },
    code = {
      -- general
      width = "block",
      min_width = 80,
      -- borders
      border = "thin",
      left_pad = 1,
      right_pad = 1,
      -- language info
      position = "right",
      language_icon = true,
      language_name = true,
      -- avoid making headings ugly
      highlight_inline = "RenderMarkdownCodeInfo",
    },
    anti_conceal = {
      disabled_modes = { "n" },
      ignore = {
        bullet = true, -- render bullet in insert mode
        head_border = true,
        head_background = true,
      },
    },
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/509
    win_options = { concealcursor = { rendered = "nvc" } },
    completions = {
      blink = { enabled = true },
      lsp = { enabled = true },
    },
  },
  ft = { "markdown", "codecompanion" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
