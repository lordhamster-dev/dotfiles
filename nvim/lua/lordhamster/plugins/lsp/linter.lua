-- An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.
return {
  -- https://github.com/mfussenegger/nvim-lint
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    require("lint").linters_by_ft = {
      -- javascript = { "eslint_d" },  -- Use conform biome instead
      -- typescript = { "eslint_d" },  -- Use conform biome instead
      -- python = { "ruff" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
