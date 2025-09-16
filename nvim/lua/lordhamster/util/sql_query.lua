local M = {}

-- 默认配置
M.config = {
  questdb = {
    host = "localhost",
    port = 9000,
    username = "admin",
    password = "quest",
  },
  postgresql = {
    host = "localhost",
    port = 5432,
    database = "postgres",
    username = "postgres",
    password = "",
  },
  default_db = "questdb", -- 或 "postgresql"
  result_window = {
    height = 20,
  },
}

-- 获取选中的文本
local function get_selected_text()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  if start_pos[2] == 0 or end_pos[2] == 0 then
    vim.notify("请先选择SQL语句", vim.log.levels.WARN)
    return nil
  end

  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Ensure lines is always a table
  if type(lines) == "string" then
    lines = { lines }
  end

  if #lines == 0 then
    return nil
  end

  -- 处理部分选择
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  return table.concat(lines, "\n")
end

local function format_questdb_result(json_str)
  local ok, data = pcall(vim.fn.json_decode, json_str)
  if not ok or not data or not data.columns or not data.dataset then
    return json_str
  end

  local columns = {}
  for _, col in ipairs(data.columns) do
    table.insert(columns, col.name)
  end

  -- Calculate max width for each column
  local col_widths = {}
  for i, name in ipairs(columns) do
    col_widths[i] = #name
  end
  for _, row in ipairs(data.dataset) do
    for i, cell in ipairs(row) do
      local cell_str = tostring(cell or "")
      if #cell_str > col_widths[i] then
        col_widths[i] = #cell_str
      end
    end
  end

  -- Build header
  local header = {}
  for i, name in ipairs(columns) do
    table.insert(header, string.format("%-" .. col_widths[i] .. "s", name))
  end
  local header_line = table.concat(header, " | ")

  -- Build separator
  local sep = {}
  for _, w in ipairs(col_widths) do
    table.insert(sep, string.rep("-", w))
  end
  local sep_line = table.concat(sep, "-+-")

  -- Build rows
  local rows = {}
  for _, row in ipairs(data.dataset) do
    local line = {}
    for i, cell in ipairs(row) do
      table.insert(line, string.format("%-" .. col_widths[i] .. "s", tostring(cell or "")))
    end
    table.insert(rows, table.concat(line, " | "))
  end

  -- Combine all
  local result_lines = { header_line, sep_line }
  vim.list_extend(result_lines, rows)
  return table.concat(result_lines, "\n")
end

-- 执行QuestDB查询
local function execute_questdb_query(sql)
  local config = M.config.questdb
  local curl_cmd = string.format('curl -s -G "%s:%d/exec" --data-urlencode "query=%s"', config.host, config.port, sql)

  local handle = io.popen(curl_cmd)
  if not handle then
    vim.notify("无法执行QuestDB查询", vim.log.levels.ERROR)
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

-- 执行PostgreSQL查询
local function execute_postgresql_query(sql)
  local config = M.config.postgresql
  local psql_cmd = string.format(
    'PGPASSWORD="%s" psql -h %s -p %d -U %s -d %s -c "%s" --csv',
    config.password,
    config.host,
    config.port,
    config.username,
    config.database,
    sql:gsub('"', '\\"')
  )

  local handle = io.popen(psql_cmd)
  if not handle then
    vim.notify("无法执行PostgreSQL查询", vim.log.levels.ERROR)
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  return result
end

-- 创建结果显示窗口
local function create_result_window(content)
  local config = M.config.result_window
  local buf = vim.api.nvim_create_buf(false, true)

  -- 设置缓冲区内容
  local lines = vim.split(content, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 设置缓冲区选项
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "sql-result"

  -- 打开新窗口显示结果
  vim.cmd("split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_height(win, config.height)
end

-- 主查询函数
function M.query_database(db_type)
  local sql = get_selected_text()
  if not sql then
    return
  end

  vim.notify("执行查询中...", vim.log.levels.INFO)

  local result
  if db_type == "questdb" then
    result = execute_questdb_query(sql)
    result = format_questdb_result(result)
  elseif db_type == "postgresql" then
    result = execute_postgresql_query(sql)
  else
    vim.notify("不支持的数据库类型: " .. db_type, vim.log.levels.ERROR)
    return
  end

  if result then
    create_result_window(result)
  else
    vim.notify("查询执行失败", vim.log.levels.ERROR)
  end
end

-- 使用默认数据库查询
function M.query_default()
  M.query_database(M.config.default_db)
end

-- 设置配置
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_user_command("SqlQueryQuestDB", function()
    M.query_database("questdb")
  end, {
    desc = "查询QuestDB数据库",
    range = true,
  })

  vim.api.nvim_create_user_command("SqlQueryPostgreSQL", function()
    M.query_database("postgresql")
  end, {
    desc = "查询PostgreSQL数据库",
    range = true,
  })

  vim.api.nvim_create_user_command("SqlQuery", function()
    M.query_default()
  end, {
    desc = "使用默认数据库查询",
    range = true,
  })
end

return M
