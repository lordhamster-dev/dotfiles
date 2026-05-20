vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/norcalli/nvim-colorizer.lua" },
})

local ensure_installed = {
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
require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype

    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    local ok_add = pcall(vim.treesitter.language.add, lang)
    if not ok_add then
      return
    end

    pcall(vim.treesitter.start, buf, lang)
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
