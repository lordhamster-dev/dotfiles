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

return M
