-- 基于 Treesitter 的代码折叠实现
-- 主要功能：
-- 1. 为支持 Treesitter 的文件类型提供智能代码折叠
-- 2. 自动处理不支持 Treesitter 的情况
-- 3. 优化性能，避免不必要的 Treesitter 解析
--
-- 特性：
-- - 跳过特殊缓冲区（help, terminal 等）
-- - 未设置文件类型时自动禁用
-- - 当 Treesitter 解析器不可用时自动降级
-- - 使用 UV 定时器优化性能，避免重复检查
--
-- 实现原理：
-- 1. 通过 foldexpr() 函数提供折叠逻辑
-- 2. 使用 skip_foldexpr 表缓存不需要 Treesitter 的缓冲区
-- 3. 使用 skip_buftype 表过滤特殊缓冲区类型
-- 4. 通过 UV 定时器定期重置 skip_foldexpr 缓存

local M = {}

M.skip_foldexpr = {} ---@type table<number,boolean>
M.skip_buftype = { help = true, terminal = true } ---@type table<string,boolean>
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then
    return "0"
  end

  -- don't use treesitter folds for non-file buffers
  if M.skip_buftype[vim.bo[buf].buftype] then
    return "0"
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

return M
