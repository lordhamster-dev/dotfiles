-- Lightweight yet powerful formatter plugin for Neovim
return {
  -- https://github.com/stevearc/conform.nvim
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local util = require("conform.util")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "reorder-python-imports", "black" },
        typescript = { "biome" },
        javascript = { "biome" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
      formatters = {
        my_black = {
          meta = {
            url = "https://github.com/psf/black",
            description = "The uncompromising Python code formatter.",
          },
          command = "black",
          args = {
            "--stdin-filename",
            "$FILENAME",
            "--quiet",
            "--skip-string-normalization",
            "-",
          },
          cwd = util.root_file({
            -- https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file
            "pyproject.toml",
          }),
        },
      },
    })
  end,
}
