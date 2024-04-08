return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local util = require("conform.util")

    conform.setup({
      formatters_by_ft = {
        python = { "reorder_python_imports", "black" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        lua = { "stylua" },
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
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
        reorder_python_imports = {
          command = "reorder-python-imports",
          args = { "-", "--exit-zero-even-if-changed" },
        },
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
