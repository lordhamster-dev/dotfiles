-- 浮动终端管理工具
-- 主要功能：
-- 1. 在编辑器底部创建浮动终端窗口
-- 2. 支持终端窗口的切换显示/隐藏
-- 3. 自动管理终端窗口状态
--
-- 特性：
-- - 窗口尺寸：25% 编辑器高度，100% 宽度
-- - 窗口位置：底部居中，带圆角边框
-- - 自动进入插入模式
-- - 复用已有终端缓冲区
-- - 窗口状态持久化
--
-- 使用方式：
-- 1. 调用 M.toggle_terminal() 切换终端显示/隐藏
-- 2. 支持通过快捷键绑定调用
--
-- 实现细节：
-- - 使用 nvim_open_win 创建浮动窗口
-- - 通过 state 表维护终端窗口状态
-- - 自动计算窗口尺寸和位置
-- - 支持窗口复用和缓冲区管理

local M = {}
local state = {
  terminal = {
    buf = -1,
    win = -1,
  },
}

-- 创建底部浮动终端窗口
local function create_float_window(opts)
  opts = opts or {}

  -- 计算窗口尺寸
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- 计算窗口位置
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- 创建或复用缓冲区
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- 配置浮动窗口
  local float_opts = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  }

  -- 创建浮动窗口
  local win = vim.api.nvim_open_win(buf, true, float_opts)

  return { buf = buf, win = win }
end

-- 切换终端窗口
function M.toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.terminal.win) then
    -- 如果窗口不存在，则创建浮动终端窗口
    state.terminal = create_float_window({ buf = state.terminal.buf })

    -- 如果缓冲区不是终端，则启动终端
    if vim.bo[state.terminal.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end

    -- 自动进入插入模式
    vim.cmd.startinsert()
  else
    -- 如果窗口存在，则隐藏窗口
    vim.api.nvim_win_hide(state.terminal.win)
    state.terminal.win = -1 -- 重置窗口 ID
  end
end

-- 支持的文件类型配置
local SUPPORTED_LANGUAGES = {
  python = "python",
  lua = "lua",
}

-- 安全地获取终端通道
local function get_terminal_channel(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return nil
  end

  local channel = vim.bo[buf].channel
  return channel and channel > 0 and channel or nil
end

-- 确保终端窗口存在并有效
local function ensure_terminal_window()
  -- 检查 state.terminal 是否存在
  if not state.terminal then
    state.terminal = {}
  end

  -- 检查窗口是否有效
  if not state.terminal.win or not vim.api.nvim_win_is_valid(state.terminal.win) then
    state.terminal = create_float_window({ buf = state.terminal.buf })

    if not state.terminal or not state.terminal.buf then
      vim.notify("Failed to create terminal window", vim.log.levels.ERROR, { title = "Run File" })
      return false
    end

    -- 确保是终端 buffer
    if vim.bo[state.terminal.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  end

  return true
end

-- 在终端中执行命令
local function execute_in_terminal(command)
  if not ensure_terminal_window() then
    return false
  end

  local channel = get_terminal_channel(state.terminal.buf)
  if not channel then
    vim.notify("Terminal channel not available", vim.log.levels.ERROR, { title = "Run File" })
    return false
  end

  -- 切换到终端窗口
  vim.api.nvim_set_current_win(state.terminal.win)
  vim.api.nvim_chan_send(channel, command .. "\r")
  vim.cmd.startinsert()

  return true
end

function M.run_file()
  -- 缓存文件类型
  local filetype = vim.bo.filetype
  local interpreter = SUPPORTED_LANGUAGES[filetype]

  if not interpreter then
    vim.notify(string.format("File type '%s' is not supported", filetype), vim.log.levels.WARN, { title = "Run File" })
    return
  end

  -- 保存文件
  vim.cmd("w")

  -- 安全地获取文件路径
  local file = vim.fn.shellescape(vim.fn.expand("%"))
  if file == "''" or file == '""' then
    vim.notify("No valid file to run", vim.log.levels.WARN, { title = "Run File" })
    return
  end

  -- 执行命令
  local command = interpreter .. " " .. file
  execute_in_terminal(command)
end

return M
