local M = {}

-- 工具函数
local function get_current_task_info()
  local current_line = vim.api.nvim_get_current_line()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  return current_line, line_num
end

local function is_markdown_task(line)
  return line:match("^%s*-%s*%[[ xX~-]?%]") ~= nil
end

local function is_todo_task(line)
  return line:match("^%s*-%s*%[[-]%]") ~= nil
end

local function is_completed_task(line)
  return line:match("^%s*-%s*%[[xX]%]") ~= nil
end

local function validate_task_line(line)
  if not is_markdown_task(line) then
    vim.notify("Current line is not a markdown task", vim.log.levels.WARN)
    return false
  end
  return true
end

local function remove_start_tag(line)
  return (line:gsub("%s*@start%(%[%[%d%d%d%d%-%d%d%-%d%d%]%]%)", ""))
end

local function add_start_tag(line)
  local date = os.date("%Y-%m-%d")
  return remove_start_tag(line) .. " @start([[" .. date .. "]])"
end

local function remove_end_tag(line)
  return (line:gsub("%s*@end%(%[%[%d%d%d%d%-%d%d%-%d%d%]%]%)", ""))
end

local function add_end_tag(line)
  local date = os.date("%Y-%m-%d")
  return remove_end_tag(line) .. " @end([[" .. date .. "]])"
end

-- 主要功能函数
function M.md_task_toggle()
  local line = vim.api.nvim_get_current_line()
  if not validate_task_line(line) then
    return
  end

  local updated_line
  if is_completed_task(line) then
    -- [x] -> [ ]
    updated_line = line:gsub("^(%s*-)%s*%[[xX]%]", "%1 [ ]")
    updated_line = remove_start_tag(updated_line)
    updated_line = remove_end_tag(updated_line)
  elseif is_todo_task(line) then
    -- [-] -> [x]
    updated_line = line:gsub("^(%s*-)%s*%[[-]%]", "%1 [x]")
    updated_line = add_end_tag(updated_line)
  else
    -- [ ] (或其他) -> [-]
    -- 使用更通用的匹配来确保状态被切换
    updated_line = line:gsub("^(%s*-)%s*%[[^%]]*%]", "%1 [-]")
    updated_line = add_start_tag(updated_line)
  end

  vim.api.nvim_set_current_line(updated_line)
end

return M
