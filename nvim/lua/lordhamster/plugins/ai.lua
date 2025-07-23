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
          description = "生成提交信息",
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
          description = "用中文解释选中的代码段",
          opts = {
            index = 3,
            is_default = true,
            short_name = "explain",
            is_slash_cmd = false,
            modes = { "v" },
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = false,
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
              content = [[请用中文解释以下代码段的功能和实现细节。]],
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Code Review"] = {
          strategy = "chat",
          description = "对选中的代码进行详细的代码审查",
          opts = {
            index = 4,
            short_name = "review",
            is_slash_cmd = false,
            modes = { "v" },
            auto_submit = true,
            user_prompt = false,
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
          prompts = {
            {
              role = constants.SYSTEM_ROLE,
              content = [[你是一个资深的代码审查专家。请从以下方面审查代码：
1. 代码质量和可读性
2. 性能优化建议
3. 潜在的 bug 和安全问题
4. 最佳实践和设计模式
5. 重构建议]],
              opts = { visible = false },
            },
            {
              role = constants.USER_ROLE,
              content = "请对以下代码进行详细的审查,并用中文回答：",
              opts = { contains_code = true },
            },
          },
        },
        ["Add Documentation"] = {
          strategy = "chat",
          description = "为代码添加文档注释",
          opts = {
            index = 5,
            short_name = "doc",
            is_slash_cmd = true,
            modes = { "v" },
            auto_submit = true,
            user_prompt = false,
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
          prompts = {
            {
              role = constants.USER_ROLE,
              content = [[请为以下代码添加详细的文档注释，包括：
1. 函数/类的用途说明
2. 参数类型和含义
3. 返回值说明
4. 使用示例（如果适用）]],
              opts = { contains_code = true },
            },
          },
        },
        ["Quick Question"] = {
          strategy = "chat",
          description = "快速编程问题咨询",
          opts = {
            index = 6,
            short_name = "ask",
            is_slash_cmd = true,
            auto_submit = false,
            adapter = {
              name = "copilot",
              model = "gpt-4.1",
            },
          },
          prompts = {
            {
              role = constants.SYSTEM_ROLE,
              content = "你是一个经验丰富的程序员助手。请用中文简洁明了地回答用户的编程问题，并在需要时提供代码示例。",
              opts = { visible = false },
            },
            {
              role = constants.USER_ROLE,
              content = "请输入你的编程问题：",
            },
          },
        },
        ["Refactor"] = {
          strategy = "chat",
          description = "重构代码以提高代码质量",
          opts = {
            index = 10,
            short_name = "refactor",
            is_slash_cmd = true,
            modes = { "v" },
            auto_submit = true,
          },
          prompts = {
            {
              role = constants.USER_ROLE,
              content = [[请重构以下代码，使其更加：
1. 模块化和可复用
2. 符合设计模式
3. 易于测试和维护
4. 遵循 SOLID 原则
请提供重构后的代码并解释改进思路。]],
              opts = { contains_code = true },
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
