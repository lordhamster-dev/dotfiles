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
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
      },
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
        tavily = function()
          return require("codecompanion.adapters").extend("tavily", {
            env = {
              api_key = function()
                return os.getenv("TAVILY_API_KEY")
              end,
            },
          })
        end,
      },
      prompt_library = {
        ["Explain Code In Chinese"] = {
          strategy = "chat",
          description = "中文代码解释",
          opts = {
            is_slash_cmd = false,
            modes = { "v" },
            short_name = "explain in chinese",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[当被要求解释代码时，请按照以下步骤进行：
1. 识别编程语言。
2. 描述代码的目的并引用编程语言的核心概念。
3. 解释每个函数或重要的代码块，包括参数和返回值。
4. 突出显示使用的任何特定函数或方法及其作用。
5. 提供代码如何融入更大应用程序的上下文（如果适用）。]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return string.format(
                  [[请解释buffer %d 中的这段代码：

```%s
%s
```
]],
                  context.bufnr,
                  context.filetype,
                  code
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
