local M = {}

-- 工具函数
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

-- 为选中文本包裹指定标记（仅支持单行）
local function wrap_selection(wrapper)
  -- 强制退出视觉模式以更新 '< 和 '> 标记
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true)

  local s_pos = vim.fn.getpos("'<")
  local e_pos = vim.fn.getpos("'>")
  local line_num = s_pos[2]
  local start_col = s_pos[3]
  local end_col = e_pos[3]

  if line_num ~= e_pos[2] then
    vim.notify("仅支持单行文本操作", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
  if not line then
    return
  end

  -- 计算最后一个字符的字节长度以确保完整提取（处理多字节字符）
  local last_char_byte = line:sub(end_col, end_col):byte()
  local char_len = 1
  if last_char_byte then
    if last_char_byte >= 240 then
      char_len = 4
    elseif last_char_byte >= 224 then
      char_len = 3
    elseif last_char_byte >= 192 then
      char_len = 2
    end
  end
  local actual_end_col = end_col + char_len - 1

  local prefix = line:sub(1, start_col - 1)
  local selection = line:sub(start_col, actual_end_col)
  local suffix = line:sub(actual_end_col + 1)

  local new_line = prefix .. wrapper .. selection .. wrapper .. suffix

  vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
end

-- 主要功能函数

-- 选中文本加粗
function M.md_text_bold()
  wrap_selection("**")
end

-- 选中文本增加行内代码块标记
function M.md_text_code()
  wrap_selection("`")
end

-- 切换任务状态
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
