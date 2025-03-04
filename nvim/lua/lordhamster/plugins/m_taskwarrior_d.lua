-- Simple utility plugin for taskwarrior in Neovim
return {
  -- https://github.com/huantrinh1802/m_taskwarrior_d.nvim
  "huantrinh1802/m_taskwarrior_d.nvim",
  version = "*",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    -- Require
    require("m_taskwarrior_d").setup({
      task_statuses = { " ", "x" },
      status_map = { [" "] = "pending", ["x"] = "completed" },
      display_due_or_scheduled = false,
    })
  end,
}
