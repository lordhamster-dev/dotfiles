local M = {}

local configured = false

local function load()
  if configured then
    return require("mini.files")
  end

  vim.pack.add({ "https://github.com/nvim-mini/mini.files" })

  configured = true

  require("mini.files").setup({
    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      close = "<esc>",
      go_in = "L",
      go_in_plus = "l",
      go_out = "h",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },

    -- Customization of explorer windows
    windows = {
      -- Maximum number of windows to show side by side
      max_number = math.huge,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      -- Width of focused window
      width_focus = 50,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 60,
    },
  })
  return require("mini.files")
end

function M.open()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
  if vim.fn.filereadable(buf_name) == 1 then
    -- Pass the full file path to highlight the file
    load().open(buf_name, true)
  elseif vim.fn.isdirectory(dir_name) == 1 then
    -- If the directory exists but the file doesn't, open the directory
    load().open(dir_name, true)
  else
    -- If neither exists, fallback to the current working directory
    load().open(vim.uv.cwd(), true)
  end
end

function M.open_cwd()
  load().open(vim.uv.cwd(), true)
end

return M
