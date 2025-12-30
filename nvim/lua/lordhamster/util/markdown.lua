local M = {}

-- 配置常量
local TASK_PATTERN = "^(%s*-%s*%[[ xX~]?%])(.*)" -- 捕获组1：前缀（含缩进），捕获组2：内容
local TAGS = {
  now = "@[[NOW]]",
  later = "@[[LATER]]",
}

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

local function validate_task_line(line)
  if not is_markdown_task(line) then
    vim.notify("Current line is not a markdown task", vim.log.levels.WARN)
    return false
  end
  return true
end

-- 转义 Lua 正则特殊字符
local function escape_pattern(text)
  return text:gsub("([%[%]%(%)%.%+%-%*%?%^%$%%])", "%%%1")
end

-- 移除所有预定义的标签并清理空格，同时保留行首缩进
local function remove_all_tags(line)
  local prefix, content = line:match(TASK_PATTERN)
  if not prefix then
    return line
  end

  for _, tag in pairs(TAGS) do
    content = content:gsub("%s*" .. escape_pattern(tag) .. "%s*", " ")
  end

  -- 清理内容部分的空格
  content = content:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")

  if content ~= "" then
    return prefix .. " " .. content
  else
    return prefix
  end
end

local function update_line_safely(line_num, new_line)
  local success, err = pcall(vim.api.nvim_buf_set_lines, 0, line_num - 1, line_num, false, { new_line })
  if not success then
    vim.notify("Failed to update line: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end
  return true
end

-- 通用任务更新处理逻辑
local function handle_task_update(tag_key)
  local current_line, line_num = get_current_task_info()
  if not validate_task_line(current_line) then
    return
  end

  -- 如果已经有该标签且任务未完成，则无需重复操作
  if tag_key and current_line:find(escape_pattern(TAGS[tag_key])) and not is_completed_task(current_line) then
    vim.notify(string.format("'%s' tag already present", tag_key), vim.log.levels.INFO)
    return
  end

  -- 统一先移除所有旧标签
  local updated_line = remove_all_tags(current_line)

  -- 如果指定了新标签，则添加
  if tag_key then
    updated_line = updated_line .. " " .. TAGS[tag_key]
  end

  if update_line_safely(line_num, updated_line) then
    local msg = tag_key and string.format("Added '%s' tag", tag_key) or "Task toggled and tags removed"
    vim.notify(msg, vim.log.levels.INFO)
  end

  -- 同步 TaskWiki 状态
  vim.cmd("TWUpdateCurrent")
  if not tag_key then
    vim.cmd("TWToggle")
  end
end

-- 主要功能函数
function M.markdown_task_toggle()
  handle_task_update(nil) -- 传入 nil 表示只移除标签并 Toggle
end

function M.markdown_task_now()
  handle_task_update("now")
end

function M.markdown_task_later()
  handle_task_update("later")
end

return M
