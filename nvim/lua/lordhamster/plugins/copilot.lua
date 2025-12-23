return {
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
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<C-]>", -- 保持优化后的上下导航
          prev = "<C-[]>",
          dismiss = "<C-m>",
        },
      },
      filetypes = {
        ["*"] = false, -- 默认禁用所有文件类型
        markdown = true,
        lua = true,
        python = true,
        html = true,
        css = true,
        typescript = true,
        javascript = true,
        rust = true,
        cpp = true,
        c = true,
        go = true,
        sh = true,
        json = true,
        yaml = true,
        toml = true,
      },
      panel = {
        enabled = false, -- 禁用面板模式
      },
    })
  end,
}
