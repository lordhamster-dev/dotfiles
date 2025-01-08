return {
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
          accept = "<Tab>", -- 改为Tab键接受建议
          accept_word = "<C-w>", -- 添加接受单词快捷键
          accept_line = "<C-e>", -- 添加接受行快捷键
          next = "<C-2>", -- 保持优化后的上下导航
          prev = "<C-1>",
          dismiss = "<C-m>",
        },
      },
      filetypes = {
        ["*"] = false, -- 默认禁用所有文件类型
        python = true,
        lua = true,
        javascript = true,
        typescript = true,
        go = true,
        rust = true,
        java = true,
        cpp = true,
      },
      panel = {
        enabled = false, -- 禁用面板模式
      },
    })
  end,
}
