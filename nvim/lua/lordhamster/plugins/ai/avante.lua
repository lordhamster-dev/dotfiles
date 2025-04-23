return {
  -- https://github.com/yetone/avante.nvim
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "deepseek_v3",
    auto_suggestions_provider = "openai", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    vendors = {
      code = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "anthropic/claude-3.7-sonnet",
        timeout = 30000,
        temperature = 0,
        max_tokens = 4096,
      },
      deepseek_r1 = {
        __inherited_from = "openai",
        endpoint = "https://ark.cn-beijing.volces.com/api/v3/",
        api_key_name = "VOLCENGINE_API_KEY",
        model = "ep-20250214111558-hp2pp",
        disable_tools = true,
        max_tokens = 4096,
      },
      deepseek_v3 = {
        __inherited_from = "openai",
        endpoint = "https://ark.cn-beijing.volces.com/api/v3/",
        api_key_name = "VOLCENGINE_API_KEY",
        model = "ep-20250328092654-7d5sh",
        disable_tools = true,
        max_tokens = 4096,
      },
    },
    mappings = {
      submit = {
        normal = "<CR>",
        insert = "<C-u>",
      },
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
