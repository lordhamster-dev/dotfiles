-- Nvim Treesitter configurations and abstraction layer
return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    -- "nvim-treesitter/nvim-treesitter-context", -- sticky header
    -- "HiPhish/nvim-ts-rainbow2",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- enable syntax highlighting
      highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        "python",
        "json",
        "javascript",
        "typescript",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "sql",
        "astro",
      },
      -- auto install above language parsers
      auto_install = true,
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = true,
      -- List of parsers to ignore installing (for "all")
      ignore_install = {},
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
          },
        },
      },
    })

    -- https://github.com/lukas-reineke/indent-blankline.nvim
    require("ibl").setup({
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "lspinfo",
          "packer",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          "dashboard",
          "TelescopePrompt",
          "TelescopeResults",
          "",
        },
      },
    })

    vim.cmd([[set nofoldenable]])
  end,
}
