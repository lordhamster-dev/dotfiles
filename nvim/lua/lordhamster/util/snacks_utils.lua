local M = {}

function M.bufdelete()
  Snacks.bufdelete()
end

function M.zen()
  Snacks.zen()
end

function M.find_files()
  Snacks.picker.files()
end

function M.find_git_files()
  Snacks.picker.git_files()
end

function M.find_help()
  Snacks.picker.help()
end

function M.find_qflist()
  Snacks.picker.qflist()
end

function M.find_recent()
  Snacks.picker.recent()
end

function M.find_keymaps()
  Snacks.picker.keymaps({
    layout = "vertical",
  })
end

function M.find_grep()
  Snacks.picker.grep()
end

function M.find_todo()
  Snacks.picker.grep({
    prompt = " ",
    -- pass your desired search as a static pattern
    search = "^\\s*- \\[ \\]",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    -- include files ignored by .gitignore
    args = { "--no-ignore" },
    -- Start in normal mode
    on_show = function()
      vim.cmd.stopinsert()
    end,
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
    search = "^\\s*- \\[x\\]",
    -- we enable regex so the pattern is interpreted as a regex
    regex = true,
    -- no “live grep” needed here since we have a fixed pattern
    live = false,
    -- restrict search to the current working directory
    dirs = { vim.fn.getcwd() },
    -- include files ignored by .gitignore
    args = { "--no-ignore" },
    -- Start in normal mode
    on_show = function()
      vim.cmd.stopinsert()
    end,
    finder = "grep",
    format = "file",
    show_empty = true,
    supports_live = false,
  })
end

function M.find_todo_comments()
  Snacks.picker.todo_comments()
end

function M.find_diagnostics()
  Snacks.picker.diagnostics_buffer()
end

function M.find_document_diagnostics()
  Snacks.picker.diagnostics()
end

function M.lazygit()
  Snacks.lazygit()
end

function M.git_log()
  Snacks.picker.git_log({
    finder = "git_log",
    format = "git_log",
    preview = "git_show",
    confirm = "git_checkout",
    layout = "vertical",
  })
end

function M.find_buffers()
  Snacks.picker.buffers({ -- I always want my buffers picker to start in normal mode
    on_show = function()
      vim.cmd.stopinsert()
    end,
    finder = "buffers",
    format = "buffer",
    hidden = false,
    unloaded = true,
    current = true,
    sort_lastused = true,
    win = {
      input = {
        keys = {
          ["d"] = "bufdelete",
        },
      },
      list = { keys = { ["d"] = "bufdelete" } },
    },
  })
end

return M
