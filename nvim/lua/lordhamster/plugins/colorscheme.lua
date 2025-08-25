return {
  -- https://github.com/catppuccin/nvim
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = { "italic" },
        functions = { "bold" },
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = { "italic" },
        properties = {},
        types = { "bold" },
        operators = { "italic" },
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        snacks = {
          enabled = true,
          indent_scope_color = "base", -- catppuccin color (eg. `lavender`) Default: text
        },
        mason = true,
        cmp = false,
        blink_cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        -- treesitter_context = true,
        -- ts_rainbow2 = true,
        which_key = true,
        harpoon = true,
        flash = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    })

    vim.cmd("colorscheme catppuccin")
    -- vim.cmd("hi LineNr guifg=#fff")
  end,
}
