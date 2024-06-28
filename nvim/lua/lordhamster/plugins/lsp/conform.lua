-- Lightweight yet powerful formatter plugin for Neovim
return {
  -- https://github.com/stevearc/conform.nvim
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        -- python = { "reorder-python-imports", "black" },
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
        typescript = { "biome" },
        javascript = { "biome" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "biome" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })
  end,
}
