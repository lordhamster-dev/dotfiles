-- 多条件实时搜索工具
-- 使用 ripgrep (rg) 实现快速文件内容搜索
-- 支持两种搜索模式：
-- 1. 单条件搜索: "keyword"
--    在所有文件中搜索包含 keyword 的内容
-- 2. 双条件搜索: "keyword  *.ext"
--    在指定扩展名文件中搜索包含 keyword 的内容
-- 示例：
--   app          -> 搜索所有文件中包含 "app" 的内容
--   app  *.lua   -> 搜索所有 .lua 文件中包含 "app" 的内容
-- 注意：两个条件之间需要用两个空格分隔

local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

function M.live_multigrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end
      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end
      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end
      -- Use vim.list_extend instead of vim.tbl_flatten
      vim.list_extend(
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
      )
      return args
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Multi Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

return M
