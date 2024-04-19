return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-context", -- sticky header
      "nvim-treesitter/nvim-treesitter-textobjects",
      { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
      "HiPhish/nvim-ts-rainbow2",
    },
    config = function()
      -- import nvim-treesitter plugin safely
      local treesitter = require("nvim-treesitter.configs")

      -- configure treesitter
      treesitter.setup({
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
        rainbow = {
          enable = true,
          -- list of languages you want to disable the plugin for
          disable = { "jsx", "cpp", "html" },
          -- Which query to use for finding delimiters
          query = "rainbow-parens",
          -- Highlight the entire buffer all at once
          strategy = require("ts-rainbow").strategy.global,
        },
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

      local s, _ = pcall(vim.cmd, "set nofoldenable")
      if not s then
        print("set nofoldenable error")
        return
      end

      -- https://github.com/lukas-reineke/indent-blankline.nvim
      require("ibl").setup({
        scope = {
          enabled = false,
        },
      })
    end,
  },
}
