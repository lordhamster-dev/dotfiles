-- Quickstart configs for Nvim LSP
return {
  -- https://github.com/neovim/nvim-lspconfig
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "RRethy/vim-illuminate", -- Neovim plugin for automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
    "saghen/blink.cmp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    -- Define sign icons for each severity
    local signs = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    }

    vim.diagnostic.config({
      signs = {
        text = signs, -- Enable signs in the gutter
      },
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

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim", "Snacks", "hs", "spoon" },
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
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { "*" },
          },
        },
      },
    })

    local keymap = vim.keymap -- for conciseness
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP definitions"
        -- keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- 使用内置 LSP 跳转到定义
        keymap.set("n", "gd", function()
          Snacks.picker.lsp_definitions()
        end, opts)

        opts.desc = "Go to declaration"
        -- keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        keymap.set("n", "gD", function()
          Snacks.picker.lsp_declarations()
        end, opts)

        opts.desc = "Show LSP references"
        -- keymap.set("n", "gr", vim.lsp.buf.references, opts) -- 使用内置 LSP 显示引用
        keymap.set("n", "gr", function()
          Snacks.picker.lsp_references()
        end, opts)

        opts.desc = "Show LSP implementations"
        -- keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- 使用内置 LSP 跳转到实现
        keymap.set("n", "gi", function()
          Snacks.picker.lsp_implementations()
        end, opts)

        opts.desc = "Float Diagnostic"
        keymap.set("n", "go", vim.diagnostic.open_float, opts)
      end,
    })
  end,
}
