return {
  {
    -- https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = false,
          debounce = 50, -- 降低debounce时间，提高响应速度
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<C-]>", -- 保持优化后的上下导航
            prev = "<C-[]>",
            dismiss = "<C-m>",
          },
        },
        filetypes = {
          ["*"] = false, -- 默认禁用所有文件类型
          lua = true,
          python = true,
          typescript = true,
          javascript = true,
          rust = true,
          cpp = true,
          c = true,
        },
        panel = {
          enabled = false, -- 禁用面板模式
        },
      })
    end,
  },
  {
    -- https://github.com/olimorris/codecompanion.nvim
    "olimorris/codecompanion.nvim",
    opts = {
      language = "Chinese",
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-sonnet-4",
              },
            },
          })
        end,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
