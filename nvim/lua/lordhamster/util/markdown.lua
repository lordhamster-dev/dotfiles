local M = {}

-- 配置常量
local TASK_PATTERN = "^%s*-%s*%[[ xX]?%]"
local TAG_PATTERNS = {
  now = { "#now", "@now" },
  later = { "#later", "@later" },
}

-- 工具函数
local function get_current_task_info()
  local current_line = vim.api.nvim_get_current_line()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  return current_line, line_num
end

local function is_markdown_task(line)
  return line:match(TASK_PATTERN) ~= nil
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

local function remove_tags(line, tag_type)
  local patterns = TAG_PATTERNS[tag_type]
  if not patterns then
    return line
  end

  for _, pattern in ipairs(patterns) do
    line = line:gsub("%s*" .. pattern .. "%s*", " ")
  end
  return line:gsub("%s+", " "):gsub("%s+$", "")
end

local function has_tag(line, tag_type)
  local patterns = TAG_PATTERNS[tag_type]
  if not patterns then
    return false
  end

  for _, pattern in ipairs(patterns) do
    if line:match(pattern) then
      return true
    end
  end
  return false
end

local function mark_as_incomplete(line)
  -- 将已完成的任务标记为未完成
  return line:gsub("^(%s*-)%s*%[[xX]%]", "%1 [ ]")
end

local function mark_as_complete(line)
  -- 将未完成的任务标记为已完成
  return line:gsub("^(%s*-)%s*%[[ ]?%]", "%1 [x]")
end

local function update_line_safely(line_num, new_line)
  local success, err = pcall(vim.api.nvim_buf_set_lines, 0, line_num - 1, line_num, false, { new_line })
  if not success then
    vim.notify("Failed to update line: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  return true
end

-- 主要功能函数
function M.complete_markdown_task()
  local current_line, line_num = get_current_task_info()

  if not validate_task_line(current_line) then
    return
  end

  -- 标记任务为完成
  local completed_line = mark_as_complete(current_line)

  -- 移除所有标签
  completed_line = remove_tags(completed_line, "now")
  completed_line = remove_tags(completed_line, "later")

  if update_line_safely(line_num, completed_line) then
    vim.notify("Task marked as completed and tags removed", vim.log.levels.INFO)
  end
end

function M.markdown_task_now()
  local current_line, line_num = get_current_task_info()

  if not validate_task_line(current_line) then
    return
  end

  if has_tag(current_line, "now") and not is_completed_task(current_line) then
    vim.notify("'now' tag already present", vim.log.levels.INFO)
    return
  end

  local updated_line = current_line
  local message = "Added 'now' tag to the task"

  -- 如果任务已完成，先取消完成状态
  if is_completed_task(updated_line) then
    updated_line = mark_as_incomplete(updated_line)
    message = "Uncompleted task and added 'now' tag"
  end

  -- 移除 later 标签并添加 now 标签
  updated_line = remove_tags(updated_line, "later")

  -- 只有在没有 now 标签时才添加
  if not has_tag(updated_line, "now") then
    updated_line = updated_line .. " #now"
  end

  if update_line_safely(line_num, updated_line) then
    vim.notify(message, vim.log.levels.INFO)
  end
end

function M.markdown_task_later()
  local current_line, line_num = get_current_task_info()

  if not validate_task_line(current_line) then
    return
  end

  if has_tag(current_line, "later") and not is_completed_task(current_line) then
    vim.notify("'later' tag already present", vim.log.levels.INFO)
    return
  end

  local updated_line = current_line
  local message = "Added 'later' tag to the task"

  -- 如果任务已完成，先取消完成状态
  if is_completed_task(updated_line) then
    updated_line = mark_as_incomplete(updated_line)
    message = "Uncompleted task and added 'later' tag"
  end

  -- 移除 now 标签并添加 later 标签
  updated_line = remove_tags(updated_line, "now")

  -- 只有在没有 later 标签时才添加
  if not has_tag(updated_line, "later") then
    updated_line = updated_line .. " #later"
  end

  if update_line_safely(line_num, updated_line) then
    vim.notify(message, vim.log.levels.INFO)
  end
end

return M
