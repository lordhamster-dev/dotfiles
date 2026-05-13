vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
})

require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = {
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
    noice = true,
    render_markdown = true,
    mason = true,
    cmp = false,
    blink_cmp = {
      style = "bordered",
    },
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    which_key = true,
    harpoon = true,
    flash = true,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})
vim.cmd("colorscheme catppuccin-nvim")

local parsers = {
  "lua",
  "python",
  "javascript",
  "typescript",
  "html",
  "css",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "vim",
  "dockerfile",
  "gitignore",
  "sql",
  "astro",
}
require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
  pattern = parsers,
  callback = function()
    vim.treesitter.start()
  end,
})

require("colorizer").setup({
  filetypes = { "css", "scss", "html", "astro" },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue or blue
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = false, -- 0xAARRGGBB hex codes
    rgb_fn = false, -- CSS rgb() and rgba() functions
    hsl_fn = false, -- CSS hsl() and hsla() functions
    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode = "background", -- Set the display mode.Available modes for `mode`: foreground,background,virtualtext
    virtualtext = "■",
    tailwind = true,
  },
})
