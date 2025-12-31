local M = {}

-- 支持的文件类型配置
local SUPPORTED_LANGUAGES = {
  python = "python",
  lua = "lua",
}

-------------------------------------------------------------------------------
-- 基础组件
-------------------------------------------------------------------------------
function M.bufdelete()
  Snacks.bufdelete()
end
function M.lazygit()
  Snacks.lazygit()
end
function M.terminal()
  Snacks.terminal()
end
function M.terminal_new()
  Snacks.terminal.open()
end
function M.zen()
  Snacks.zen()
end

-------------------------------------------------------------------------------
-- 文件浏览器 (Explorer)
-------------------------------------------------------------------------------
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#explorer
function M.explorer()
  Snacks.explorer({
    sort = { fields = { "sort" } },
    supports_live = true,
    tree = true,
    watch = true,
    diagnostics = false,
    diagnostics_open = false,
    git_status = true,
    git_status_open = false,
    git_untracked = true,
    follow_file = false,
    focus = "list",
    -- layout = { -- the layout config
    --   layout = { -- the layout itself
    --     width = 40,
    --     height = 0,
    --   },
    -- },
    hidden = true,
    ignored = true,
  })
end

-------------------------------------------------------------------------------
-- 智能搜索与项目管理
-------------------------------------------------------------------------------
-- 结合了 Buffers, Recent 和 Files 的超级搜索
function M.smart()
  Snacks.picker.smart({ hidden = true, ignored = false })
end

function M.find_files()
  Snacks.picker.files({ hidden = true, ignored = false })
end

function M.find_git_files()
  Snacks.picker.git_files()
end

function M.find_qflist()
  Snacks.picker.qflist()
end

function M.find_recent()
  Snacks.picker.recent()
end

function M.find_todo_comments()
  Snacks.picker.todo_comments()
end

function M.find_diagnostics()
  Snacks.picker.diagnostics_buffer()
end

function M.find_document_diagnostics()
  Snacks.picker.diagnostics()
end

function M.find_buffers()
  Snacks.picker.buffers({
    -- I always want my buffers picker to start in normal mode
    on_show = function()
      vim.cmd.stopinsert()
    end,
    finder = "buffers",
    format = "buffer",
    layout = "select",
    hidden = false,
    unloaded = true,
    current = true,
    sort_lastused = false,
    win = {
      input = {
        keys = {
          ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
          ["d"] = { "bufdelete", mode = { "n" } },
          ["l"] = { "confirm", mode = { "n" } },
        },
      },
      list = { keys = { ["d"] = "bufdelete" } },
    },
  })
end

function M.find_commands()
  Snacks.picker.commands()
end

-------------------------------------------------------------------------------
-- 内容搜索 (Grep)
-------------------------------------------------------------------------------
function M.find_grep()
  Snacks.picker.grep()
end

function M.find_word()
  Snacks.picker.grep_word()
end

function M.find_links()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "\\[\\[",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

function M.find_todo_tasks()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "^\\s*- \\[[ -]\\]",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    -- include files ignored by .gitignore
    args = { "--no-ignore" },
    -- Start in normal mode
    -- on_show = function()
    --   vim.cmd.stopinsert()
    -- end,
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

function M.find_complete_tasks()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "^\\s*- \\[[xX]\\]",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    -- include files ignored by .gitignore
    args = { "--no-ignore" },
    -- Start in normal mode
    -- on_show = function()
    --   vim.cmd.stopinsert()
    -- end,
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

-------------------------------------------------------------------------------
-- Git 增强
-------------------------------------------------------------------------------
function M.git_log()
  Snacks.picker.git_log({ layout = "vertical" })
end
function M.git_status()
  Snacks.picker.git_status()
end

-------------------------------------------------------------------------------
-- 系统辅助
-------------------------------------------------------------------------------
function M.find_help()
  Snacks.picker.help()
end
function M.find_keymaps()
  Snacks.picker.keymaps({ layout = "vertical" })
end
function M.find_notifications()
  Snacks.picker.notifications()
end

-------------------------------------------------------------------------------
-- 实用工具 (Utils)
-------------------------------------------------------------------------------
function M.run_file()
  local filetype = vim.bo.filetype
  local interpreter = SUPPORTED_LANGUAGES[filetype]
  if not interpreter then
    vim.notify("Filetype not supported", vim.log.levels.WARN)
    return
  end
  vim.cmd("w")
  local file = vim.fn.shellescape(vim.fn.expand("%"))
  Snacks.terminal.open(interpreter .. " " .. file)
end

return M
