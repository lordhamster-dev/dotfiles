local M = {}
local state = {
  terminal = {
    buf = -1,
    win = -1,
  },
}

-- 创建底部终端窗口
local function create_bottom_window(opts)
  opts = opts or {}
  -- 计算终端窗口的高度（窗口总高度的 1/4）
  local height = math.floor(vim.o.lines * 0.25)

  -- 创建或复用缓冲区
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- 创建一个无文件的临时缓冲区
  end

  -- 在底部打开一个水平分割窗口
  vim.cmd("botright split") -- 在底部打开一个新窗口
  local win = vim.api.nvim_get_current_win() -- 获取当前窗口的 ID

  -- 设置窗口高度
  vim.api.nvim_win_set_height(win, height)

  -- 将缓冲区附加到窗口
  vim.api.nvim_win_set_buf(win, buf)

  return { buf = buf, win = win }
end

-- 切换终端窗口
function M.toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.terminal.win) then
    -- 如果窗口不存在，则创建底部终端窗口
    state.terminal = create_bottom_window({ buf = state.terminal.buf })

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

return M
