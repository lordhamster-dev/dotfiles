local M = {}

local configured = false

local function load()
  if configured then
    return require("conform")
  end

  vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

  configured = true

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
      javascript = { "biome", "biome-organize-imports" },
      typescript = { "biome", "biome-organize-imports" },
      typescriptreact = { "biome", "biome-organize-imports" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      yaml = { "prettier" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      rust = { "rustfmt", lsp_format = "fallback" },
      ["_"] = { "trim_whitespace" },
    },
  })
  return require("conform")
end

function M.format()
  load().format({ async = true }, function(err, did_edit)
    vim.notify(err or (did_edit and "Formatted buffer" or "Buffer already formatted"), vim.log.levels.INFO)
  end)
end

function M.format_and_save()
  load().format({ async = true }, function(err, did_edit)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end

    -- Save the buffer after formatting
    vim.cmd("write")
    vim.notify(did_edit and "Formatted and saved buffer" or "Buffer already formatted, saved", vim.log.levels.INFO)
  end)
end

return M
