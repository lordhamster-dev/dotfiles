local M = {}

-- 工具函数
local function get_current_task_info()
  local current_line = vim.api.nvim_get_current_line()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  return current_line, line_num
end

local function is_markdown_task(line)
  return line:match("^%s*-%s*%[[ xX~]?%]") ~= nil
end

local function is_completed_task(line)
  return line:match("^%s*-%s*%[[xX]%]") ~= nil
end

local function is_deleted_task(line)
  return line:match("^%s*-%s*%[~%]") ~= nil
end

local function validate_task_line(line)
  if not is_markdown_task(line) then
    vim.notify("Current line is not a markdown task", vim.log.levels.WARN)
    return false
  end
  return true
end

local function remove_done_tag(line)
  return (line:gsub("%s*@done%[%[%d%d%d%d%-%d%d%-%d%d%]%]", ""))
end
local function add_done_tag(line)
  local date = os.date("%Y-%m-%d")
  return remove_done_tag(line) .. " @done[[" .. date .. "]]"
end

-- 主要功能函数
function M.md_task_toggle()
  local line, _ = get_current_task_info()
  if not validate_task_line(line) then
    return
  end

  local updated_line
  if is_completed_task(line) then
    -- [x] -> [~] (标记为删除/未完成)，移除标记
    updated_line = line:gsub("^(%s*-)%s*%[[xX]%]", "%1 [~]")
    updated_line = remove_done_tag(updated_line)
    vim.api.nvim_set_current_line(updated_line)
  elseif is_deleted_task(line) then
    -- [~] -> [ ] (还原为未完成)，移除标记
    updated_line = line:gsub("^(%s*-)%s*%[~%]", "%1 [ ]")
    updated_line = remove_done_tag(updated_line)
    vim.api.nvim_set_current_line(updated_line)
  else
    -- [ ] -> [x] (标记为完成)，添加标记
    updated_line = line:gsub("^(%s*-)%s*%[[ ]?%]", "%1 [x]")
    updated_line = add_done_tag(updated_line)
    vim.api.nvim_set_current_line(updated_line)
  end
end

return M
