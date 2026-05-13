vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
})

local signs = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = "󰠠 ",
  [vim.diagnostic.severity.INFO] = " ",
}

vim.diagnostic.config({
  signs = { text = signs },
  virtual_text = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

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

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "clangd",
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
    "markdown_oxide",
  },
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "clang-format", -- c,cpp formatter
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "biome", -- js linter
    "ruff", -- python linter
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim", "Snacks", "hs" },
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    -- set keybinds
    opts.desc = "Show LSP definitions"
    -- keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- 使用内置 LSP 跳转到定义
    vim.keymap.set("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, opts)

    opts.desc = "Show LSP references"
    -- keymap.set("n", "gr", vim.lsp.buf.references, opts) -- 使用内置 LSP 显示引用
    vim.keymap.set("n", "gr", function()
      Snacks.picker.lsp_references()
    end, opts)

    opts.desc = "Show LSP implementations"
    -- keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- 使用内置 LSP 跳转到实现
    vim.keymap.set("n", "gi", function()
      Snacks.picker.lsp_implementations()
    end, opts)

    opts.desc = "Float Diagnostic"
    vim.keymap.set("n", "go", vim.diagnostic.open_float, opts)
  end,
})

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "biome",
  "ruff",
  "clangd",
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
  "markdown_oxide",
})

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
