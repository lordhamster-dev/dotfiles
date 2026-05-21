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
    layout = {
      layout = {
        width = 30,
        height = 0,
      },
    },
    hidden = true,
    ignored = true,
  })
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

function M.format()
  require("conform").format({ async = true }, function(err, did_edit)
    vim.notify(err or (did_edit and "Formatted buffer" or "Buffer already formatted"), vim.log.levels.INFO)
  end)
end

function M.format_and_save()
  require("conform").format({ async = true }, function(err, did_edit)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end

    -- Save the buffer after formatting
    vim.cmd("write")
    vim.notify(did_edit and "Formatted and saved buffer" or "Buffer already formatted, saved", vim.log.levels.INFO)
  end)
end

return M
