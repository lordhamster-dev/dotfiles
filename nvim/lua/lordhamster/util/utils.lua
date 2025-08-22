local M = {}

function M.close_buffer_preserve_window()
  local cur_buf = vim.api.nvim_get_current_buf()
  -- Try to find an alternate listed buffer
  local alt_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      buf ~= cur_buf
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.api.nvim_get_option_value("buflisted", { scope = "local", buf = buf })
    then
      alt_buf = buf
      break
    end
  end
  if alt_buf then
    vim.api.nvim_set_current_buf(alt_buf)
  else
    vim.cmd("enew") -- create a new empty buffer
  end
  vim.api.nvim_buf_delete(cur_buf, { force = true })
end

function M.run_python()
  if vim.bo.filetype == "python" then
    vim.cmd("w")
    -- Open terminal in split and run Python
    vim.cmd("split | terminal python " .. vim.fn.shellescape(vim.fn.expand("%")))
  elseif vim.bo.filetype == "lua" then
    vim.cmd("w")
    -- Open terminal in split and run Lua
    vim.cmd("split | terminal lua " .. vim.fn.shellescape(vim.fn.expand("%")))
  else
    vim.notify("Not a Python file", vim.log.levels.WARN, { title = "Run Python" })
  end
end

return M
