-- Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
return {
  -- https://github.com/williamboman/mason.nvim
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "none",
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    })

    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    require("mason-lspconfig").setup({
      ensure_installed = {
        "clangd",
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "html",
        "emmet_ls",
        "cssls",
        "tailwindcss",
        "ts_ls",
        "angularls",
        "bashls",
        "jsonls",
        "yamlls",
        "astro",
        -- "marksman",
        "markdown_oxide",
      },
      automatic_installation = true,
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        -- "black", -- python formatter
        "clang-format", -- c,cpp formatter
        "prettier", -- prettier formatter
        -- "reorder-python-imports", -- python formatter
        "stylua", -- lua formatter
        -- "eslint_d", -- js linter
        "biome", -- js linter
        "ruff", -- python linter
      },
    })
  end,
}
