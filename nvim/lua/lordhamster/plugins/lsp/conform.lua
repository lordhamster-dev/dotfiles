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
        typescript = { "biome", "biome-organize-imports" },
        javascript = { "biome", "biome-organize-imports" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "biome" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        ["_"] = { "trim_whitespace" },
      },
      -- format_on_save = {
      --   lsp_fallback = true,
      --   async = false,
      --   timeout_ms = 1000,
      -- },
    })
  end,
}

-- biome.jsonc
-- {
--     "$schema": "https://biomejs.dev/schemas/2.2.0/schema.json",
--     "assist": { "actions": { "source": { "organizeImports": "on" } } },
--     "linter": {
--         "enabled": true,
--         "rules": {
--             "a11y": {
--                 "noSvgWithoutTitle": "off",
--                 "useMediaCaption": "off"
--             },
--             "complexity": {
--                 "noForEach": "off"
--             },
--             "performance": {
--                 "noAccumulatingSpread": "error"
--             },
--             "style": {
--                 "noParameterAssign": "off",
--                 "useImportType": "off"
--             }
--         }
--     },
--     "formatter": {
--         "enabled": true,
--         "indentStyle": "space",
--         "indentWidth": 4,
--         "lineWidth": 120
--     }
-- }
