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
