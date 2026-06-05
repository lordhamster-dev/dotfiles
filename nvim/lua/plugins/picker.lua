local M = {}

-- local configured = false

-- local function load()
--   if configured then
--     return require("fff")
--   end
--
--   vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })
--
--   configured = true
--
--   vim.g.fff = {
--     lazy_sync = true,
--     prompt_vim_mode = false,
--     layout = {
--       height = 0.8,
--       width = 0.8,
--       prompt_position = "top",
--       preview_position = "right",
--       preview_size = 0.5,
--       flex = { size = 130, wrap = "top" },
--       show_scrollbar = true,
--       path_shorten_strategy = "middle_number", -- 'middle_number' | 'middle' | 'end' | 'start'
--       anchor = "center",
--     },
--     keymaps = {
--       close = "<Esc>",
--       select = "<CR>",
--       select_split = "<C-s>",
--       select_vsplit = "<C-v>",
--       select_tab = "<C-t>",
--       move_up = { "<Up>", "<C-k>" },
--       move_down = { "<Down>", "<C-j>" },
--       preview_scroll_up = "<C-u>",
--       preview_scroll_down = "<C-d>",
--       toggle_debug = "<F2>",
--       cycle_grep_modes = "<S-Tab>",
--       cycle_previous_query = "<C-p>",
--       toggle_select = "<Tab>",
--       send_to_quickfix = "<C-q>",
--       focus_list = "<leader>l",
--       focus_preview = "<leader>p",
--     },
--     debug = { enabled = true, show_scores = true },
--   }
--   return require("fff")
-- end
--
-- vim.api.nvim_create_autocmd("PackChanged", {
--   callback = function(ev)
--     local name, kind = ev.data.spec.name, ev.data.kind
--     if name == "fff.nvim" and (kind == "install" or kind == "update") then
--       if not ev.data.active then
--         vim.cmd.packadd("fff.nvim")
--       end
--       require("fff.download").download_or_build_binary()
--     end
--   end,
-- })

-------------------------------------------------------------------------------
-- 智能搜索与项目管理
-------------------------------------------------------------------------------
function M.find_files()
  Snacks.picker.files({ hidden = true, ignored = false })
end

function M.find_git_files()
  Snacks.picker.git_files()
end

function M.find_qflist()
  Snacks.picker.qflist()
end

function M.find_recent()
  Snacks.picker.recent()
end

function M.find_diagnostics()
  Snacks.picker.diagnostics_buffer()
end

function M.find_document_diagnostics()
  Snacks.picker.diagnostics()
end

function M.find_buffers()
  Snacks.picker.buffers({
    -- I always want my buffers picker to start in normal mode
    on_show = function()
      vim.cmd.stopinsert()
    end,
    finder = "buffers",
    format = "buffer",
    layout = "select",
    hidden = false,
    unloaded = true,
    current = true,
    sort_lastused = false,
    win = {
      input = {
        keys = {
          ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
          ["d"] = { "bufdelete", mode = { "n" } },
          ["l"] = { "confirm", mode = { "n" } },
        },
      },
      list = { keys = { ["d"] = "bufdelete" } },
    },
  })
end

function M.find_commands()
  Snacks.picker.commands()
end

-------------------------------------------------------------------------------
-- 内容搜索 (Grep)
-------------------------------------------------------------------------------
function M.find_grep()
  Snacks.picker.grep()
end

function M.find_word()
  Snacks.picker.grep_word()
end

function M.find_links()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "\\[\\[",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

function M.find_todo_tasks()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "^\\s*- \\[[ -]\\]",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    -- include files ignored by .gitignore
    args = { "--no-ignore" },
    -- Start in normal mode
    -- on_show = function()
    --   vim.cmd.stopinsert()
    -- end,
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

function M.find_complete_tasks()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "^\\s*- \\[[xX]\\]",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    -- include files ignored by .gitignore
    args = { "--no-ignore" },
    -- Start in normal mode
    -- on_show = function()
    --   vim.cmd.stopinsert()
    -- end,
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

-------------------------------------------------------------------------------
-- 系统辅助
-------------------------------------------------------------------------------
function M.find_help()
  Snacks.picker.help()
end
function M.find_keymaps()
  Snacks.picker.keymaps({ layout = "vertical" })
end
function M.find_notifications()
  Snacks.picker.notifications()
end

return M
