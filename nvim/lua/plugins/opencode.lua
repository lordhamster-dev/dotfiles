local M = {}
local opencode
local opencode_cmd = "opencode --port"

local function tmux_opencode_pane_id()
  local panes = vim.fn.systemlist({ "tmux", "list-panes", "-F", "#{pane_id}:#{pane_current_command}" })
  for _, pane in ipairs(panes) do
    local parts = vim.split(pane, ":")
    if #parts >= 2 and parts[#parts] == "opencode" then
      return parts[1]
    end
  end
  return nil
end

local function load_opencode()
  if opencode then
    return opencode
  end

  vim.pack.add({
    { src = "https://github.com/nickjvandyke/opencode.nvim" },
  })

  vim.g.opencode_opts = {
    server = {
      start = function()
        if not tmux_opencode_pane_id() then
          vim.fn.system({ "tmux", "split-window", "-h", "-d", opencode_cmd })
        end
      end,
      stop = function()
        local pane_id = tmux_opencode_pane_id()
        if pane_id then
          vim.fn.system({ "tmux", "kill-pane", "-t", pane_id })
        end
      end,
      toggle = function()
        local pane_id = tmux_opencode_pane_id()
        if pane_id then
          vim.fn.system({ "tmux", "select-pane", "-t", pane_id })
        else
          vim.fn.system({ "tmux", "split-window", "-h", opencode_cmd })
        end
      end,
    },
  }

  opencode = require("opencode")
  return opencode
end

function M.ask()
  load_opencode().ask("", { submit = true })
end

function M.ask_buffer()
  load_opencode().ask("@buffer: ", { submit = true })
end

function M.ask_this()
  load_opencode().ask("@this: ", { submit = true })
end

function M.snacks_picker_send(...)
  load_opencode().snacks_picker_send(...)
end

return M
