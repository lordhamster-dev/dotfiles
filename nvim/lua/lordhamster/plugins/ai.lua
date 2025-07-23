local fmt = string.format

local constants = {
  LLM_ROLE = "llm",
  USER_ROLE = "user",
  SYSTEM_ROLE = "system",
}

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
        ["Generate a Commit Message"] = {
          strategy = "chat",
          description = "Generate a commit message",
          opts = {
            index = 2,
            is_default = true,
            is_slash_cmd = true,
            short_name = "commit",
            auto_submit = true,
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
          prompts = {
            {
              role = constants.USER_ROLE,
              content = function()
                return fmt(
                  [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

```diff
%s
```
]],
                  vim.fn.system("git diff --no-ext-diff --staged")
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Explain"] = {
          strategy = "chat",
          description = "Explain how code in a buffer works",
          opts = {
            index = 3,
            is_default = true,
            short_name = "explain",
            is_slash_cmd = false,
            modes = { "v" },
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
          prompts = {
            {
              role = constants.SYSTEM_ROLE,
              content = [[When asked to explain code, follow these steps:

1. Identify the programming language.
2. Describe the purpose of the code and reference core concepts from the programming language.
3. Explain each function or significant block of code, including parameters and return values.
4. Highlight any specific functions or methods used and their roles.
5. Provide context on how the code fits into a larger application if applicable.]],
              opts = {
                visible = false,
              },
            },
            {
              role = constants.USER_ROLE,
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return fmt(
                  [[请用中文解释buffer %d 中的这段代码：

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
