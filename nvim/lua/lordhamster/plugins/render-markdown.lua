-- Plugin to improve viewing Markdown files in Neovim
return {
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown", "Avante" },
    -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
    -- There are two special states for unchecked & checked defined in the markdown grammar.
    checkbox = {
      -- Turn on / off checkbox state rendering.
      enabled = true,
      -- Additional modes to render checkboxes.
      render_modes = false,
      -- Determines how icons fill the available space.
      -- | inline  | underlying text is concealed resulting in a left aligned icon |
      -- | overlay | result is left padded with spaces to hide any additional text |
      position = "inline",
      unchecked = {
        -- Replaces '[ ]' of 'task_list_marker_unchecked'.
        icon = "󰄱 ",
        -- Highlight for the unchecked icon.
        highlight = "RenderMarkdownUnchecked",
        -- Highlight for item associated with unchecked checkbox.
        scope_highlight = nil,
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'.
        icon = "󰸞 ",
        -- Highlight for the checked icon.
        highlight = "RenderMarkdownChecked",
        -- Highlight for item associated with checked checkbox.
        scope_highlight = nil,
      },
    },
  },
  ft = { "markdown", "Avante" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
}
